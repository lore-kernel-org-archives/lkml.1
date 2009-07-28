Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZG1WHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZG1WHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbZG1WHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:07:30 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:61670 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbZG1WH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:07:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=DaJ40tOEmri08BjhC8CKj+zKyYoUSgUwcD8DfSlLGhzk8IQfbWoExM1f1e7dboHI6L
         hMDzmGSzKA215wsxcnd4RRsI+CPoIS82fa1mVcF+MMj67kv2a6VvkOlFrQerCyh5Qjea
         w8ng3uWSTb95ZpWLyOvi4sJv76nZm62dFzC40=
Message-ID: <4A6F769E.9080101@gmail.com>
Date: Wed, 29 Jul 2009 00:07:26 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mm-commits@vger.kernel.org, roel.kluin@gmail.com
Subject: Re: + cyclades-read-buffer-overflow.patch added to -mm tree
References: <200907282152.n6SLqsfG029093@imap1.linux-foundation.org>
In-Reply-To: <200907282152.n6SLqsfG029093@imap1.linux-foundation.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2009 11:52 PM, akpm@linux-foundation.org wrote:
> Subject: cyclades: fix read buffer overflow
> From: Roel Kluin <roel.kluin@gmail.com>
> 
> irq is declared with size NR_CARDS (4), but the loop containing this
> segment runs up until NR_ISA_ADDRS (16), possibly reading from irq[i] (and
> trying to use the result)
> 
> Identified by the Parfait static scanner.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> Cc: Jiri Slaby <jirislaby@gmail.com>

Acked-by: Jiri Slaby <jirislaby@gmail.com>

Thanks!

> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

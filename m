Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbYLJWB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbYLJWB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 17:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbYLJWBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 17:01:17 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:56544 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbYLJWBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 17:01:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ZLJ9aUsGLjqnyLxuNgVXMP308Gr5mSnXMbdrpMgJCFhxuLpmIY8HO7QtemhnM5oYdn
         37uy5Q7Nf7QHExduQiMy3CQXh/y81znWR4rd6gK1NnMOLTGTgoh1EX4iqEYYPrU1GpP8
         SfkGS4tgrdINGTbuWrhSWAk15Zj5iRV6YApe0=
Message-ID: <49403C26.5050402@gmail.com>
Date: Wed, 10 Dec 2008 23:01:10 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Hannes Eder <hannes@hanneseder.net>
CC: Karsten Keil <kkeil@suse.de>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/9] mISDN: fix sparse warnings
References: <493feab4.0aaa660a.7938.3213@mx.google.com>
In-Reply-To: <493feab4.0aaa660a.7938.3213@mx.google.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2008 04:13 PM, Hannes Eder wrote:
> Should 'plx_lock' be declared in a header file?  Or is it really
> neccessart to export it?

As there is no other user, I vote for unexporting it.

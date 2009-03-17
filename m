Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbZCQVl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbZCQVl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbZCQVlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:41:17 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:42406 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbZCQVlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:41:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uM4ZTFxvRkGqiPwziGD/dogX0yjKQFQoZIFPcYzgGFroB5JRz2H027Dlzyg5c5TQL5
         bnOVlLoAJrZabhvxdUwlj3VHHQZD7LpPjeYxpCjQaLR4VxUJdHnVLknT3d0nbGNxZlEt
         BIdn5vN+3OtGc4+CDIiPE5PTN8A6keAJImezg=
Subject: Re: [PATCH] radio-mr800.c: Missing mutex include
From: Alexey Klimov <klimov.linux@gmail.com>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org, video4linux-list@redhat.com
In-Reply-To: <1237323618-6464-1-git-send-email-abogani@texware.it>
References: <1237323618-6464-1-git-send-email-abogani@texware.it>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 00:42:08 +0300
Message-Id: <1237326128.2141.17.camel@tux.localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 22:00 +0100, Alessio Igor Bogani wrote:
> radio-mr800.c uses struct mutex, so while <linux/mutex.h> seems to be
> pulled in indirectly by one of the headers it already includes, the
> right thing is to include it directly.


Hello, Alessio

Patch looks okay for my eyes.
If it useful it should be applied.

Thank you!

Mauro, if patch is okay please apply it.
If you need my ack - here it is:
Acked-by: Alexey Klimov <klimov.linux@gmail.com>

-- 
Best regards, Klimov Alexey


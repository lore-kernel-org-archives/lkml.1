Return-Path: <linux-kernel-owner+w=401wt.eu-S1759883AbZAGUhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883AbZAGUhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 15:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758277AbZAGUhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 15:37:31 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:34162 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558AbZAGUha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 15:37:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=qVo1niw3lYF6oCE9x4Isk2vtLMvFfLHdIjYRi9Y+tmRljm8a4tHSWZRTULDb4bT4fq
         0RJuA2SVsDIX3kx+DpuG9ysEgbqm6oBOTktfla1plVtYERhdjyVv3lhcYbc0A1ZNyu6f
         YH9CKxBLhO15wZQJooaSbjuYsyv/EMItkZnEE=
Message-ID: <49651285.1020302@gmail.com>
Date: Wed, 07 Jan 2009 21:37:25 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Nico -telmich- Schottelius <nico-linux-20090106@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: Suspend issues on all latest kernels!
References: <20090107193559.GA4306@denkbrett.schottelius.org>
In-Reply-To: <20090107193559.GA4306@denkbrett.schottelius.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2009 08:35 PM, Nico -telmich- Schottelius wrote:
> Hello!
> 
> Suspend fails on Lenovo X200 with
> 
>   - 2.6.28-next-20090107-ikn
>   - 2.6.28-ikn-06859-gede6f5a
> 
> When doing echo mem > /sys/power/state, the
> "Suspending consoles..." message appears, the "moon" is blinking,
> but the system stays in this state (waited 10 minutes) forever.

Could you test
http://lkml.org/lkml/2009/1/7/67
? If it doesn't help, add no_console_suspend on kernel command line and post the
suspend hang output.

Thanks.

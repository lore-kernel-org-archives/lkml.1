Return-Path: <linux-kernel-owner+w=401wt.eu-S932403AbXGVXW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbXGVXW6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764881AbXGVXWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:22:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:34091 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761790AbXGVXWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:22:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TwgSfT9AnmU1ARUXbo569XaWWSWhm60TE6OYF+CcQ4ZFjmEzUcYEosH8mA7+JqEXJNDiO74VEpE69VwyQI2NBSZF+1kyCQgd/wXdk87l9hx5yVvYOQcOBuExPzX78GiBYT8EnHIa5bT2RSXbT2u/j/o0pn/0Qc0eRmGR7DRCa3A=
Subject: Re: Problems with framebuffer in 2.6.22-git17
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Adrian McMenamin <adrianmcmenamin@gmail.com>
Cc: linux-kernel@vger.kernel.org, lethal@users.sourceforge.net
In-Reply-To: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com>
References: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 07:22:43 +0800
Message-Id: <1185146563.6370.8.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 19:41 +0100, Adrian McMenamin wrote:
> I ma having problems with the pvr2 fb on the Dreamcast in 2.6.22-git17
> - when the code is executed it appears to lock the Dreamcast up.
> 
> The problem seems to be:
> 
>  fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
> 
> In drivers/video/fbmem.c
> 
> This hasn't been an issue before, so are there any recent changes that
> might have caused this?

What's the last kernel that worked for you? Can you also post your
config?

> 
> (fb_notifier_call_chain calls a succession of stubs ending in
> __blocking_notifier_call_chain in kernel/sys.c)
> 

Try reverting commit a66ad56eb2c9644717da4d7f05f971d6786145e3.

Tony



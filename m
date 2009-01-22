Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbZAVUYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbZAVUYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZAVUX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:23:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:6848 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZAVUX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:23:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EUDhgXKJj7R7VYN5ut55MzcYEZfcZuu1jn1E+Y+xcDa/SnK4OytK5UP2y8IP/+VNOx
         bgiMRAn2rmdmMsBtPrmoHpVryqn8BKLeYVc73YvrVRXBzjdEr0rZRKqgL4m/x/eudHiO
         n+IvZTKnF/Y/pgRxwVQR98xZG3PLmHQHVDkxQ=
MIME-Version: 1.0
In-Reply-To: <46e1c7760901221153i3fa9b2b6w8432d60119545c8f@mail.gmail.com>
References: <46e1c7760901221023r2766a57ey4564d05c05751b6e@mail.gmail.com>
	 <20090122190432.55696781@lxorguk.ukuu.org.uk>
	 <46e1c7760901221153i3fa9b2b6w8432d60119545c8f@mail.gmail.com>
Date: Thu, 22 Jan 2009 22:23:54 +0200
Message-ID: <46e1c7760901221223x480a3d4ctded298ae89ac4187@mail.gmail.com>
Subject: Re: [PATCH] vt - fb: hide cursor in graphics mode
From: Risto Suominen <risto.suominen@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: adaplas@pol.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/22 Risto Suominen <risto.suominen@gmail.com>:
> 2009/1/22 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>>
>> NAK. You need to work out what your real problem is I think. When we
>> enter graphics mode we hide the cursor automatically and always have done.
>>
>> See set_cursor() and also do_blank_screen(1)
>>
> Could it be that console != fg_console, and we never reach do_blank_screen?
>
> Risto
>
Wait, I have a better theory: fbcon_is_inactive() hinders
fbcon_cursor() from doing anything, if the vc is already in graphics
mode.

Risto

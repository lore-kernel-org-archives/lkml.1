Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbZAVTx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbZAVTx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 14:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbZAVTxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 14:53:48 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:18855 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbZAVTxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:53:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F3CAfLVrBJW0pESCSzqjXVP1/GeXvy0iMxdBUVgbKM/AQEHuWd9nUPhMeE14Z2KVuc
         FdsrnWK6x4wuHvJOwgu50sxvfbKvgrqF2VUYC3++MJJza/mgZiwYakMZ9zNXmw1DPP1D
         Cluf3Pt7++GOwlSNGydLTjxQm4Fs4YPmQsdNU=
MIME-Version: 1.0
In-Reply-To: <20090122190432.55696781@lxorguk.ukuu.org.uk>
References: <46e1c7760901221023r2766a57ey4564d05c05751b6e@mail.gmail.com>
	 <20090122190432.55696781@lxorguk.ukuu.org.uk>
Date: Thu, 22 Jan 2009 21:53:45 +0200
Message-ID: <46e1c7760901221153i3fa9b2b6w8432d60119545c8f@mail.gmail.com>
Subject: Re: [PATCH] vt - fb: hide cursor in graphics mode
From: Risto Suominen <risto.suominen@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: adaplas@pol.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/22 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>
> NAK. You need to work out what your real problem is I think. When we
> enter graphics mode we hide the cursor automatically and always have done.
>
> See set_cursor() and also do_blank_screen(1)
>
Could it be that console != fg_console, and we never reach do_blank_screen?

Risto

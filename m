Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbZJVQWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbZJVQWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbZJVQWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:22:06 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:43599 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbZJVQWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:22:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=sgExsSkVIsjOTgxzpANCEPBHKXyM7TpXSEcJpOQ2fgOcBuy21kwF41tfVwNOm++oj4
         RQzihA6mXwLCsOXDJBJajaWpgMP7G+bKAAW0l1vCjSp63vp2hkzO0XAm5nbvSKdcctku
         xe5CSL+f8fvj3EioysOHPNlfUbxrnguaiM0V4=
Date: Thu, 22 Oct 2009 09:22:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not  work
	anymore
Message-ID: <20091022162202.GA18031@core.coreip.homeip.net>
References: <928C125D-D36B-47C9-A549-3EE502C9EC73@gmail.com> <20091015215944.GA9845@core.coreip.homeip.net> <4ADF6237.9070004@tremplin-utc.net> <200910211320.16339.dmitry.torokhov@gmail.com> <4AE0840C.8070801@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AE0840C.8070801@tremplin-utc.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 06:10:52PM +0200, Éric Piel wrote:
> Op 21-10-09 22:20, Dmitry Torokhov schreef:
> > 
> > Nothing, as far as I can tell... I see you typing "qwerty"... Does the 
> > keyboard work in console (let's say if you boot in run level 3 to take X out 
> > of the picture)? Could you please try compiling evbug module - it will show if 
> > keyboard events are propagated through input core. Also, whta driver are you 
> > using in X? Legacy keyboard or evdev?
> In the console (in init 3), I haven't managed to reproduce it. In xorg,
> the keyboard input uses evdev. Now I've just tried "evtest
> /dev/input/event4", when the keyboard doesn't work... and I see the key
> presses!
> 
> So I guess it rules out a bug in the kernel, and I have to talk with the
> people from Xorg, right?
> 

Yep... but it is still wierd since evdev driver works fine for me...
Could it be you are using either too old or too new version of X?

-- 
Dmitry

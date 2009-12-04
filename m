Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZLDMIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZLDMIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 07:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbZLDMI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 07:08:29 -0500
Received: from lo.gmane.org ([80.91.229.12]:42636 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042AbZLDMI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 07:08:29 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [POWER] battery calibration parameters from sysfs
Date: Fri, 4 Dec 2009 11:34:25 +0000
Message-ID: <1n8nu6-4va.ln1@chipmunk.wormnet.eu>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Cc: linux-embedded@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij <linus.walleij@stericsson.com> wrote:
> 
> [snipped]
> 
> Is probably not very elegant. (Or is it?) Would it be permissible to
> pass in a table like:
> 
> cat >/sys/.../v_vs_cap <<EOF
> x0,y0
> x1,y1
> x2,y2
> EOF
> 
> And have the kernel parse x,y pairs up to EOF?
> 
> Or would it be preferable to do this thing by creating some
> misc device node like /dev/battery0 and a custom ioctl()?
> 
> Or is there some other way I haven't thought of?
> 
Although I'm a 'nobody' I would probably go for:
----
echo x0,y0:x1,y1:....
----

Pairs are seperated by ':' whilst values with ','.  I guess you could 
just use comma's all the way but I personally say that reduces 
readability...also means that maybe one day you want to pass only one or 
three values...the format could still work.

Easy to parse, a one liner, no fixed length, fits in with the existing 
use, etc etc.

Cheers

-- 
Alexander Clouter
.sigmonster says: You'll be sorry...


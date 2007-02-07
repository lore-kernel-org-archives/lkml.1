Return-Path: <linux-kernel-owner+w=401wt.eu-S1161342AbXBGOkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161342AbXBGOkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 09:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161343AbXBGOkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 09:40:46 -0500
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:55559 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1161342AbXBGOkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 09:40:45 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Feb 2007 09:40:44 EST
X-AntiVirus: PTMail-AV 0.3-0.88.6
Subject: Re: 2.6.20 [drm:i915_wait_irq] *ERROR*
From: Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>
To: Dave Airlie <airlied@gmail.com>
Cc: landwer@free.fr, dri-devel <dri-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <21d7e9970702061625u24e09305v63c7f9780b02de93@mail.gmail.com>
References: <1170806926.5669.6.camel@cocoduo>
	 <21d7e9970702061625u24e09305v63c7f9780b02de93@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 07 Feb 2007 14:34:05 +0000
Message-Id: <1170858845.2956.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2007-02-07 at 11:25 +1100, Dave Airlie wrote:
> >
> > I'm running a 2.6.20 kernel on my macbook. When running an openGL
> > application, if the opengl window's region is moved somewhere outside
> > the screen limits, then keyboard locks, I can only move the mouse,
> > nothing response. I can only reboot the box by pressing the power button
> > 5 seconds. /var/log/syslog contains that :
> >
> > kernel: [drm:i915_wait_irq] *ERROR* i915_wait_irq: EBUSY -- rec: 730561 emitted: 730570
> >
> > The macbook uses an intel card :
> >
> > 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express Memory Controller Hub (rev 03)
> > 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
> >
> 
> I'm cc'ing dri devel in case anyone there knows why this might happen...
> 
> Dave.

maybe try disable : 
Section "ServerFlags"
    Option  "AIGLX" "off"
EndSection

Section "Extensions"
    Option "Composite" "Disable"
EndSection

and use: 
Option "Legacy3D" "true




Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbYJJJmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbYJJJmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYJJJmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:42:38 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:53895 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751765AbYJJJmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:42:37 -0400
Date: Fri, 10 Oct 2008 11:42:35 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Tim Bird <tim.bird@am.sony.com>
cc: Adrian Bunk <bunk@kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC - size tool for kernel build system
In-Reply-To: <48EE9A1C.8040301@am.sony.com>
Message-ID: <Pine.LNX.4.64.0810101141340.12257@vixen.sonytel.be>
References: <48EBD268.50208@am.sony.com> <20081009152151.GB17013@cs181140183.pp.htv.fi>
 <48EE9A1C.8040301@am.sony.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-231544204-1223631755=:12257"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-231544204-1223631755=:12257
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 9 Oct 2008, Tim Bird wrote:
> Adrian Bunk wrote:
> > The building blocks that would be useful are IMHO:
> > - a make target that generates a report for one kernel
> >   (like the checkstack or export_report targets)
> > - a script that compares two such reports and outputs the
> >   size differences
> > 
> > That's also easy to do, and if that's what's wanted I can send a patch 
> > that does it.
> 
> I took a stab at this with the attached two scripts.  These are
> not quite ready for prime time, but show the basic idea.
> I only have a partial list of subsystems, and am skipping the
> runtime data collection, for now.
> 
> I have only made the scripts, not any make targets for them.

Seems to work fine, after I hacked my $CROSS_COMPILE prefix into the hardcoded
nm launch.

Thanks!

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-231544204-1223631755=:12257--

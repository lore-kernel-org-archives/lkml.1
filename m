Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbXGCRTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbXGCRTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbXGCRTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:19:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbXGCRTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:19:33 -0400
Date: Tue, 3 Jul 2007 13:19:13 -0400
From: Dave Jones <davej@redhat.com>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
Cc: Arne Georg Gleditsch <argggh@dolphinics.no>,
       Florian Attenberger <valdyn@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
Message-ID: <20070703171913.GD18725@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>,
	Arne Georg Gleditsch <argggh@dolphinics.no>,
	Florian Attenberger <valdyn@gmail.com>,
	linux-kernel@vger.kernel.org
References: <87d4z97bks.fsf@pelargir.dolphinics.no> <F1D642E5A91BC94D9504EC83AE19E6B0128A63@ecqcmtlmail3.quebec.int.ec.gc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0128A63@ecqcmtlmail3.quebec.int.ec.gc.ca>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 11:36:42AM -0400, Fortier,Vincent [Montreal] wrote:
 > > -----Message d'origine-----
 > > De : linux-kernel-owner@vger.kernel.org 
 > > [mailto:linux-kernel-owner@vger.kernel.org] De la part de 
 > > Arne Georg Gleditsch
 > > 
 > > Florian Attenberger <valdyn@gmail.com> writes:
 > > > yep, controlled by ntpd.
 > > > You're right according to
 > > > ftp://hpiers.obspm.fr/iers/bul/bulc/bulletinc.33
 > > > that event shouldn't have been there.
 > > 
 > > I'm not all that versed in ntp-ish, but it appears that the 
 > > leap second insertion should be propagated through the ntp protocol.
 > > Whether the leap second in question came from a ntp server 
 > > giving out wrong data or from a misinterpretation or bug in 
 > > ntpd is of course hard to say, but either way turning the 
 > > clock back is unlikely to reconstruct the circumstances.  An 
 > > interesting exercise might be to code up a small program to 
 > > call adjtimex with timex.status |= STA_INS, to see if this 
 > > can trigger the problem.  (The bogus leap second might be a 
 > > red herring entirely, of course...)
 > 
 > You are probably right, I did tried to reproduce the problem without
 > success...
 > 
 > Although it is wierd that it happend only on 2.6.21 kernels... It did
 > not happend on any of my workstations/servers running either 2.6.18 or
 > 2.6.20.  
 > 
 > Could dynticks be involved?

I saw it on a box that happened to have lockdep enabled.
(I run it everywhere thankfully).  This is what it looked like..
http://www.codemonkey.org.uk/junk/img_0421.jpg

	Dave

-- 
http://www.codemonkey.org.uk

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbZLDSyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbZLDSyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZLDSx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:53:59 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:51513 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbZLDSx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:53:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=CANXJ78PSD5gRE7RLx8gnxNaq3W3aUbuOhB+OGazqWkl35wIxrqdS7UhcFl9D830cO
         I5B8RdLiSL5TOmTAM2SkpCfEQ3urMd3d5Sa6T1uYs6WgRFJuG5CZFwYhiJMV5IQE93Ok
         nS6qfvLqay/NyvVCXF8xlA/eojCPe+Q1Sx9ik=
MIME-Version: 1.0
Date: Fri, 4 Dec 2009 13:45:58 -0500
Message-ID: <81bfc67a0912041045vbcfa16cja48f1ede3259c9c4@mail.gmail.com>
Subject: 2.6.29.6 supported? intel graphics bug
From: Caleb Cushing <xenoterracide@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

while testing my e1000e bug found a problem that I suspect correlates
to newer x11 drivers / older kernel. sorry if this is being sent to
the wrong place in that event (although without confirmation I suspect
the same developers work on both). kde wouldn't finish logging in for
me and I was no longer able to switch to VT's I suspect because of
kwin's compositing turning on.

quick info for hardware. I'll be honest when I say this isn't a
problem for me as the only reason I went back to that kernel was for
network testing.

agpgart-intel 0000:00:00.0: Intel G33 Chipset
agpgart-intel 0000:00:00.0: detected 7164K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
fb0: inteldrmfb frame buffer device

Total of 4 processors activated (19159.42 BogoMIPS).
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
i915 0000:00:02.0: irq 25 for MSI/MSI-X
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

--
Caleb Cushing

http://xenoterracide.blogspot.com

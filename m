Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab0BGNkA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 08:40:00 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:48108 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab0BGNj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 08:39:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=KvWzPIAdxX1wW9JL8R/4mAsjOKyevmnhj4wk29vY4dQy+jJEW3i2M6cZ8MneuS57Rq
         ZzB8rn0YDgOMelM1hKJwWD3/LW7ArMOcCCsxSG5VD4Erjo6CpsKNhK4pkQviKws5ifn8
         w9AcvhDzhLqjsoaVnRzyRzEo0n26IHLLW1kiM=
MIME-Version: 1.0
Date: Sun, 7 Feb 2010 08:39:57 -0500
Message-ID: <deaa866a1002070539v47807006lc2f217d5c16a6b51@mail.gmail.com>
Subject: Multi-card DRI interface timeframe
From: Robert Bradbury <robert.bradbury@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have: Radeon R3450 & Intel i915. Want multiple X terminals and multiple screens.

Excerpted logs:
Xorg.2.log:(II) RADEONHD(0): [DRI] installation complete
Xorg.3.log:(EE) RADEONHD(0): [dri] DRIScreenInit failed.  Disabling DRI.

Xterms :0 and :1 are like :3.  I am under the impression that only one
VT (here :2) can get the DRI interface.  That terminals is fast, the
rest much less so. (Its also annoying that the DRI gets assigned to
the VT/X started but assume thats an Xorg scheduling issue).
I am under the impression that how many VTs/X Servers can use the DRI
is a kernel issue.

Q1: What is the kernel development time frame for allowing the active
VT to take control of the DRI interface?

Now, this machine has both the Intel i915 graphics interface and F3450
card with 2 video interfaces.  The X server (via Xorg.conf) has no
problem setting up both hardware controllers.  It is possible to do
dual screen (like xinerama but using a large virtual screen) across
both Radeon interfaces.  However one cannot do "dual screen" (or
tri-screen) across both hardware controllers.  (Of course in this
situation it seems that switching VTs would involve switching both
controllers so it would seem to me to involve kernel issues.)

Q2: What is the kernel development time frame for allowing mixing and
matching video controller hardware across multiple screens?

I realize that this is not the focus of the LKML per se but the KMS,
DRI, and controller drivers all *are* in the Kernel.  If other forums
would be better for these types of questions then please suggest them.

Thank you,
Robert Bradbury

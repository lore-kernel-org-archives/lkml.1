Return-Path: <linux-kernel-owner+w=401wt.eu-S1756462AbZJ2TBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbZJ2TBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbZJ2TBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:01:54 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:53537 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874AbZJ2TBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:01:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=I2MHMHIz066Awp6RI5/0YcnRTON57wBk7Xzq6TPJiLQfmCXpqGcijXCQLc9Jeu1GiU
         eYCOiF6RgeJvOlBkgf1FoMFKM1rQqXH8FkFmKuGHRBQNCjtlVTnVaKEXTz1TjcpGOHbr
         aUK4xlCf7wcCHLthyjZEQ00HwOUMsYUAxzv74=
MIME-Version: 1.0
Date: Thu, 29 Oct 2009 15:01:22 -0400
Message-ID: <d0626390910291201m6e8121abq831867715f5d7d5@mail.gmail.com>
Subject: How to immunize a process from the OOM Killer
From: Juan Miscaro <jmiscaro@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I'm running 2.6.24 on Ubuntu.

I've got a OOM Killer gone wild.  I have plenty of free memory (over
40 GB) and lots of processes are being murdered.  Anyway, I would like
to first prevent a few processes from being killed in the hopes of
buying me time (users can work) to discover why the killer is being
invoked in the first place.

I've read in a few places [1] that in order to immunize a process you
need to modify the value of /proc/PID/oom_adj.  Thing is, such files
cannot be edited directly.  How do I achieve my goal?

Thank you,

--
jm

[1]
http://linux-mm.org/OOM_Killer
http://lwn.net/Articles/317814/

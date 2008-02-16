Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYBPEzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYBPEzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 23:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbYBPEyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 23:54:54 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:54057 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbYBPEyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 23:54:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OahJxEi5aD6nj3DQgR57klHeukO6VHTJpFTDBN0z5aF0p59MweWB4DIIi8Aiwrc1U/SBBJeQnpff8G1A+mH589VYjuB+Cn20Yvi9oj9M5g0lSeBkUtppmXs/M/6Hm2ySAs5YM/34PimKl0SxKaCIGzIzIwi4fSTVu+cNqHpENmE=
Message-ID: <8bd0f97a0802152054l6d6a9b0aq8226c168006834b8@mail.gmail.com>
Date: Fri, 15 Feb 2008 23:54:51 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Wim Van Sebroeck" <wim@iguana.be>
Subject: common watchdog interface: handling of suspend/resume
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i'm not sure if it is possible to integrate this into the common code
(be great if we could), but we should codify the expected behavior for
the suspend/resume functions.  from looking at the 8 that implement
the pm functions, they seem to all do:
suspend(): turn off the watchdog
resume(): turn on the watchdog if it was running

some other issues raised:
 - this device should not be able to be selective suspended ... in
other words, you only want to "suspend" the watchdog if the whole
system is going to be suspend
 - should the nowayout option be checked at all ?
-mike

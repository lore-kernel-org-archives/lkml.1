Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbXFZMah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbXFZMah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 08:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbXFZMaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 08:30:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:64792 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbXFZMaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 08:30:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=kkRqb3X//bf/2YDGH2l6Dp94+abc3NzhhozXFUneDWuFcnhcXmyxrseFvIdv8UGAUD6841zsbMm5yjJlnhH7j2503XJOjF+wKb4KK9wSxj1ATZoZX0yz9CW5qcNUeDAb9WYxPHoLUMqzTQUtDHQ7K/yTNrOErm5Ausoc68GdESU=
Message-ID: <5d5443650706260530x11b6ce8el542eabbe3800b4d6@mail.gmail.com>
Date: Tue, 26 Jun 2007 18:00:22 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com
Subject: [PATCH 0/17] Add Texas Instruments OMAP LCD driver-v2
Cc: "Tony Lindgren" <tony@atomide.com>, imre.deak@solidboot.com,
       juha.yrjola@solidboot.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

This patch series contains Texas Instruments OMAP LCD framebuffer
drivers. This driver is divided into

* main omapfb driver, which handles most common functions across
processor series, like platform driver registration, ioctl handling,
much like fb skeleton.

This driver then gets through the callback based on the
internal/external lcd controller and panel registered to it based on
processor and board. Internal/External LCD controller as per lcd panel
data registration is being done in separate files and so does patches.

Overall this patches contains framebuffer driver for TI OMAP1
(OMAP1510/1610/1710) and OMAP2 (OMAP2420/2430) and external
controllers used in Nokia Internal Tablets (N770/N800).

These drivers were very well tested on OMAP GIT [1] tree from long
time. Most of the code for this driver is written by Imre Deak
<imre.deak@solidboot.com>.

Also CCed to LKML for wider review, and this v2 went through checkpatch.pl and
I have modified the patches to accept most of checkpatch comments.

-- 
--Trilok Soni
PS: Sorry, all the patches will be as attachment (not inline one), as
I can only use gmail webmail interface, NO pop access allowed, where I
am working.

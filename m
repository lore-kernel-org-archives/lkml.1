Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYGPAVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYGPAVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYGPAVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:21:03 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:9200 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbYGPAVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:21:02 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2008 20:21:02 EDT
Date: Tue, 15 Jul 2008 19:10:38 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,  use it in more drivers.
Message-ID: <20080716001038.GA1242918@hiwaay.net>
References: <aPHZW-47Y-17@gated-at.bofh.it> <aPIje-4ST-15@gated-at.bofh.it> <aPV6W-3jN-41@gated-at.bofh.it> <aPX8A-7qb-21@gated-at.bofh.it> <aPXii-7G3-25@gated-at.bofh.it> <aPXs2-7Vn-25@gated-at.bofh.it> <aPXUQ-aU-1@gated-at.bofh.it> <aPY4D-G7-23@gated-at.bofh.it> <aPZ0H-2ls-21@gated-at.bofh.it> <aPZap-2zq-15@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487D0ED1.7010003@garzik.org>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Jeff Garzik  <jeff@garzik.org> said:
>* Red Hat driver disks.  The build process is unaware of the need to 
>bundle firmware.  Any use with Fedora (or, later, RHEL) will result in a 
>non-working driver, for the simple reason that firmware is not copied 
>onto the image.

Then Red Hat driver disks are already broken, as there are current
modules (e.g. qla2xxx) that require external firmware.

>* Embedded projects like OpenWRT, that divide up kernel modules into 
>multiple packages.  Since it's not just one big package, you have to 
>update each package's list of files to include the newly split-out 
>firmwares.  Failure to do so results in a successful build set of 
>packages... of drivers that lack their firmware.

AFAIK OpenWRT and the like don't just throw in random new kernel
releases without at least reading release notes and testing.
-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.

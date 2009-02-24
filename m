Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbZBXTJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbZBXTJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 14:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZBXTIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 14:08:55 -0500
Received: from eazy.amigager.de ([213.239.192.238]:49631 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbZBXTIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 14:08:54 -0500
Date: Tue, 24 Feb 2009 20:08:50 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Suspend regression with 2.6.29-rc
Message-ID: <20090224190850.GA27800@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with 2.6.28, I have sporadic suspend failures with suspend to RAM on my
Mac mini core duo (Intel Core Duo, i945 chipset and graphics).  I
traced it down to the DRM driver: without X and DRM unloaded, I had
more than 200 suspens in a row without any failure.

With 2.6.29-rc6-00029-gf7e603a, even with DRM unloaded the computer
hangs at suspend time after some attempts.  I also tried other
2.6.29-rc kernels, and all had unstable suspend behaviour.  I can't
give any further details, as the console is dark and I have no serial
console.  Any hints what I might try except for bisecting?

Regards,
Tino

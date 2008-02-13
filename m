Return-Path: <linux-kernel-owner+w=401wt.eu-S933091AbYBMRnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091AbYBMRnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbYBMRnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:43:15 -0500
Received: from frankvm.xs4all.nl ([80.126.170.174]:35901 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753450AbYBMRnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:43:14 -0500
X-Greylist: delayed 4664 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 12:43:14 EST
Date: Wed, 13 Feb 2008 17:25:28 +0100
From: Frank van Maarseveen <frankvm@frankvm.com>
To: linux-kernel@vger.kernel.org
Subject: Machine check exception with a kernel dependency
Message-ID: <20080213162528.GA32635@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On at least two Dell optiplex 755 systems with a Core 2 Duo I get

Feb 13 15:14:01 inari CPU 1: Machine Check Exception: 0000000000000004 
Feb 13 15:14:01 inari CPU 0: Machine Check Exception: 0000000000000005 
Feb 13 15:14:01 inari Bank 0: b200004000000800 
Feb 13 15:14:01 inari Bank 5: b200221024080400 

2.6.22.10 shows the problem, 2.6.24.2 ditto but I'm unable to reproduce
it with 2.6.24-rc8. BIOS upgrade didn't help. Removing all PCI[e] cards
didn't help either.

Does it make sense to try to pinpoint the problem to a particular
changeset (using git bisect I guess but I've never used it) or is the
hardware just broken?

-- 
Frank

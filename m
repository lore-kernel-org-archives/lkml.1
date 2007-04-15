Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbXDOBjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbXDOBjB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 21:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXDOBjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 21:39:00 -0400
Received: from cobalt0.barnhard.net ([216.181.81.129]:37976 "EHLO
	cobalt0.barnhard.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbXDOBjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 21:39:00 -0400
Date: Sun, 15 Apr 2007 02:38:49 +0100
From: Dale Amon <amon@vnl.com>
To: linux-kernel@vger.kernel.org
Subject: Problem with ufs nextstep in 2.6.18 (debian)
Message-ID: <20070415013848.GG4770@vnl.com>
Mail-Followup-To: Dale Amon <amon@vnl.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux, the choice of a GNU generation
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I recently noticed that I can no longer read my 
images of NeXTstep floppies on certain machines.
All are running an up to date etch distribution
but the difference between where I can read or not
read seems to be the linux version. On a 2.6.18
machine:

# mount -t ufs -o ro,ufstype=nextstep,loop nextfloppy-fd0a.ufs /floppy
# ls /floppy
ls: reading directory /floppy: Input/output error

On a 2.6.13 machine it still works fine:

# mount -t ufs -o ro,ufstype=nextstep,loop nextfloppy-fd0a.ufs /floppy
# ls /floppy/
private
# ls /floppy/private
Drivers

Have there been any recent changes that would cause a 
breakage in this area?


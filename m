Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbZFHLE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbZFHLE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 07:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbZFHLEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 07:04:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:49036 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbZFHLEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 07:04:22 -0400
Date: Mon, 8 Jun 2009 13:04:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Guido <bugzilla.kernel.org@starbase12.cjb.net>,
       Remi Cattiau <remi@cattiau.com>
Subject: Re: [Bug #13411] Barscanner (USB HID Keyboard) stopped functioning
 in kernels >= 2.6.28
In-Reply-To: <AN6kEAA5GQ.A.g8.vj7KKB@chimera>
Message-ID: <alpine.LNX.2.00.0906081302010.7457@wotan.suse.de>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <AN6kEAA5GQ.A.g8.vj7KKB@chimera>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Jun 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13411
> Subject		: Barscanner (USB HID Keyboard) stopped functioning in kernels >= 2.6.28
> Submitter	: Guido <bugzilla.kernel.org@starbase12.cjb.net>
> Date		: 2009-05-31 12:21 (8 days old)

This is apparently caused by vendor releasing two different hardware 
products under the same VID/PID and just one of them needing blacklist 
entry. Sigh.

Waiting for verbose lsusb output from Remi, so that we could compare it 
with the output provided by the bug reporter, to see what else could be 
done to distinguish the devices from each other.

-- 
Jiri Kosina
SUSE Labs

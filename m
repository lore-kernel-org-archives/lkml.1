Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZFWRW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZFWRW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbZFWRWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:22:19 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:56231 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbZFWRWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:22:18 -0400
X-Greylist: delayed 1335 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2009 13:22:18 EDT
Date: Tue, 23 Jun 2009 19:00:06 +0200
To: linux-kernel@vger.kernel.org
Subject: finding reasons for disk spin ups
Message-ID: <20090623170006.GC30649@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
(please cc)

is there a way I can find the reasons why my disk is spinning up again
and again? I tried to monitor io with
	iotop -o -d 0.01 -b -qqq -t
but sometimes the disks spins up without anything showing up.
The partitions are mounted with noatime.

Is there any kernel interface telling me why/whcih process called for
the sync so that the disk wakes up?

Thanks a lot

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
`My doctor says that I have a malformed public-duty gland
and a natural deficiency in moral fibre, and that I am
therefore excused from saving Universes.'
                 --- Ford's last ditch attempt to get out of helping
                 --- Slartibartfast.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbYLHBru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbYLHBru (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 20:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYLHBrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 20:47:42 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:40222 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbYLHBrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 20:47:41 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: [REGRESSION] commit "ide: respect current DMA setting during resume" breaks resume on PowerBook G4
Date: Mon, 08 Dec 2008 14:47:37 +1300
Message-ID: <87wseb8mkm.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e9eb8388306364295308132265c00bea685f409f ("ide: respect current
DMA setting during resume") breaks resume on my PowerBook G4.

I get a stream of the following:

    hda: task_out_intr: status=0x51 { DriveReady SeekComplete Error }
    hda: task_out_intr: error=0x04 { DriveStatusError }
    ide: failed opcode was: unknown

and generally the machine hangs, although once it reported

    ide0: reset: success

and resumed successfully.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood

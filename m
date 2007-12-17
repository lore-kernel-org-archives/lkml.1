Return-Path: <linux-kernel-owner+w=401wt.eu-S1763518AbXLQPEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763518AbXLQPEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 10:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758069AbXLQPDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 10:03:49 -0500
Received: from kandzendo.ru ([195.178.208.66]:40124 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758249AbXLQPDq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 10:03:46 -0500
Cc: netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [0/4] DST: Distributed storage.
In-Reply-To: <20071214133747.GC31971@2ka.mipt.ru>
X-Mailer: Patch sending script by Greg Kroah-Hartman
Date: Mon, 17 Dec 2007 18:03:38 +0300
Message-Id: <11979038181687@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: lkml <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Distributed storage.

I'm pleased to announce the 12'th release of the distributed
storage subsystem (DST).

DST allows to form a storage on top of local and remote nodes
and combine them into linear or mirroring setup, which in
turn can be exported to remote nodes.

Short changelog:
 * new improved mirroring algorithm.
	This algorithm uses sliding window approach for full resync
	and write log for partial resync.
 * fixed number of typos and debug cleanups
 * update inode size when linear algorithm changes the size of the
	storage in run time
 * extended number of sysfs files and documentation for them
 * fixed leak in local export node setup
 * name is 'Dancing with the smoked neutrino' now

Overall list of features of the DST can be found on project's homepage:

http://tservice.net.ru/~s0mbre/old/?section=projects&item=dst

DST is also exported as a git tree available for clone and pull from
http://tservice.net.ru/~s0mbre/archive/dst/dst.git

Interested reader can test DST with 2.6.23 tree too
(it should compile fine, but was not tested).

DST passed all FS tests in LTP with XFS (modulo MAX_LOCK_DEPTH too low bug:
[ 8398.605691] BUG: MAX_LOCK_DEPTH too low!
[ 8398.609641] turning off the locking correctness validator.

this is not DST problem though), but it was not performed with
offline/online nodes.

Thank you.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>



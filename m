Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbXBFQCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbXBFQCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXBFQCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:02:18 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:56867 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbXBFQCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:02:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=iKRJNGvT6lnsWqhFGrFAheEQ2Ff+rA+/NOrpnSTaMWcz8Y5OEquhkgyJ+qjZ20sWBoXJeMSDLZTY5oZ3TRmR6AaTt7u36KH9dT7e7My/I0p9PcTZQbzU8Ag+/M0K/+DTZDVec0hthfv9dVyC9cFVIgG/sMFo4htm/iGFaITFIlw=
Date: Tue, 6 Feb 2007 18:02:04 +0200
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00] A series of patches to use ARRAY_SIZE macro
Message-ID: <20070206160204.GA8991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi lovely list :),

Follows (as thread replies) is a series of patches to use ARRAY_SIZE 
macro defined in kernel.h.

It's complementary to previous patch serieses that dealt with this 
issue under `video' (drivers/media/video), `net' (drivers/net) and 
`arch' subtrees.

 drivers/acpi/toshiba_acpi.c            |    2 +-
 drivers/atm/he.c                       |    2 +-
 drivers/atm/idt77252.c                 |    8 ++++----
 drivers/atm/nicstarmac.c               |    4 +++-
 drivers/char/agp/intel-agp.c           |    3 ++-
 drivers/char/drm/drm_proc.c            |    2 +-
 drivers/infiniband/core/device.c       |    3 ++-
 drivers/isdn/capi/capi.c               |    4 ++--
 drivers/isdn/capi/capidrv.c            |    4 ++--
 drivers/isdn/hardware/eicon/debug.c    |   30 +++++++++++++++---------------
 drivers/isdn/hardware/eicon/message.c  |   23 +++++++++++------------
 drivers/isdn/hardware/eicon/platform.h |    4 ----
 drivers/kvm/kvm_svm.h                  |    3 ++-
 drivers/kvm/svm.c                      |    5 +++--
 drivers/kvm/vmx.c                      |    6 +++---
 drivers/md/md.c                        |    6 +++---
 drivers/media/dvb/bt8xx/dst.c          |    2 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c    |    3 ++-
 drivers/media/dvb/frontends/cx24110.c  |    4 ++--
 drivers/media/dvb/frontends/cx24123.c  |    6 +++---
 drivers/media/dvb/ttpci/av7110_ir.c    |    3 ++-
 drivers/s390/cio/device_id.c           |    3 ++-
 drivers/w1/slaves/w1_therm.c           |    6 +++---
 fs/reiserfs/do_balan.c                 |    5 +++--
 kernel/rcutorture.c                    |    2 +-
 sound/oss/au1550_ac97.c                |    4 ++--
 sound/oss/es1371.c                     |    3 ++-
 sound/oss/nec_vrc5477.c                |    4 ++--
 sound/oss/soundcard.c                  |    5 +++--
 sound/oss/swarm_cs4297a.c              |    3 ++-
 30 files changed, 85 insertions(+), 77 deletions(-)

Thanks,
-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com

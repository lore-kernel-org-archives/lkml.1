Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbZI2KgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbZI2KgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 06:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZI2KgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 06:36:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbZI2KgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 06:36:08 -0400
Date: Tue, 29 Sep 2009 12:33:53 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCHv2 0/4] scsi: export and clean up headers
Message-ID: <20090929103353.GA11183@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements a minor cleanup of exported scsi headers,
and adds export of headers that are de-facto used by userspace.
The patches are on top of 2.6.32-rc1.
Can these be queued for 2.6.32?
Thanks.


Michael S. Tsirkin (4):
  scsi: consistent use of __u8 in scsi/scsi.h
  scsi: make scsi/scsi.h headers_check clean
  scsi: export scsi_ioctl.h and sg.h headers
  scsi: export scsi_tgt_if.h

 include/scsi/Kbuild |    3 +++
 include/scsi/scsi.h |   12 ++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

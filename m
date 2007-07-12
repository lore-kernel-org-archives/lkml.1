Return-Path: <linux-kernel-owner+w=401wt.eu-S932706AbXGLPpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbXGLPpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 11:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbXGLPpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 11:45:31 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:47921 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbXGLPpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 11:45:30 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 00/10] IB/ehca: Multiple Event Queues, MR/MW rework, large page MRs, fixes
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Thu, 12 Jul 2007 17:45:26 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200707121745.27592.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Building on top of the last patch series, this set of patches adds multi-EQ
support, fixes a few nits (including formatting), refactors the MR/MW code
and adds support for large page MRs. Another patch set will follow.

Note that patch 7 will introduce a few lines over 80 chars that will be
unindented in patch 8 - I hope that's okay with you.

The patches, in detail, are:

[01/10] adds support for multiple event queues (ie interrupt sources)
[02/10] fixes a problem with HW autodetection
[03/10] \
[04/10] |
[05/10] | These refactor and clean up the MR/MW code. We split them into
[06/10] | bite-sized chunks for easier review of the changes.
[07/10] | 
[08/10] / 
[09/10] fixes a lot of checkpatch.pl warnings
[10/10] adds large page MR support for eHCA2

The patches should apply cleanly, in order, against Roland's git. Please
review the changes and apply the patches if they are okay.

Regards,
  Joachim

-- 
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com



Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbZIXMdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbZIXMdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbZIXMdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:33:12 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:47520 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZIXMdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:33:11 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz14ffOzz1202hzzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KQH6UY-04-3VB-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 00/10] amd64_edac fixes
Date: Thu, 24 Sep 2009 14:32:38 +0200
Message-ID: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 24 Sep 2009 12:32:56.0632 (UTC) FILETIME=[24E7BB80:01CA3D13]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

here are a bunch of AMD64 EDAC fixes which have piled up
in the last couple of weeks. I'll push them to Linus after
b8a4754147d61f5359a765a3afd3eb03012aa052 in x86/cpu has gone upstream
and in case there are no complaints.

 drivers/edac/amd64_edac.c     |  289 +++++++++++++++++++++--------------------
 drivers/edac/amd64_edac.h     |   33 ++---
 drivers/edac/amd64_edac_inj.c |   49 ++++++-
 3 files changed, 206 insertions(+), 165 deletions(-)


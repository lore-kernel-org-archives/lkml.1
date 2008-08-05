Return-Path: <linux-kernel-owner+w=401wt.eu-S1761428AbYHERwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428AbYHERwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756194AbYHERw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:52:29 -0400
Received: from ottawa-hs-64-26-148-84.d-ip.magma.ca ([64.26.148.84]:33991 "EHLO
	gonzo.int.wil.cx" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755433AbYHERw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:52:28 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jgarzik@pobox.com, Matt_Domsch@dell.com
Subject: LibATA support for long sectors
Date: Tue,  5 Aug 2008 13:26:45 -0400
Message-Id: <1217957207-23116-1-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ATA-8 defines two different methods for increasing the length of
sectors.  Long Physical Sectors increase the native sector size
of the disc while pretending to the OS that sectors are still 512 bytes.
Long Logical Sectors increase the length of the reported sector.  This
patch series adds support for both.  It does not add support for
non-power-of-2 sector sizes as they have not been fully specified yet.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110Ab0ATO3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0ATO3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 09:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253Ab0ATO3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 09:29:23 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:34371 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670Ab0ATO3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 09:29:23 -0500
Date: Wed, 20 Jan 2010 15:29:43 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: linux-kernel@vger.kernel.org, htejun@gmail.com, linux-ide@vger.kernel.org,
       jgarzik@pobox.com
Cc: siccegge@stud.informatik.uni-erlangen.de,
       Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Unreferenced config in kernel (libata-sff.c) source (NO_ATA_LEGACY)
Message-ID: <20100120142943.GE3580@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

./drivers/ata/libata-sff.c:2948:#if defined(CONFIG_NO_ATA_LEGACY)

	That's the only place where it is checked for
NO_ATA_LEGACY. As this Item does appear nowhere in KConfig and
therefor is not selectable I'm wondering whether that small Code
fragment should be dropped or a new KConfig option should be added?

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger


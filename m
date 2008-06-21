Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYFUKPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYFUKPl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 06:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYFUKP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 06:15:27 -0400
Received: from nn7.de ([85.214.94.156]:47137 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638AbYFUKPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 06:15:06 -0400
Subject: hdparm -M acoustic management for sata disks?
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 21 Jun 2008 12:14:55 +0200
Message-Id: <1214043295.17302.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

why is acoustic management via hdparm not supported for sata disks?

# hdparm -M /dev/sda

/dev/sda:
 acoustic      = not supported

# sudo hdparm -M 254 /dev/sda

/dev/sda:
 setting acoustic management to 254
 HDIO_DRIVE_CMD:ACOUSTIC failed: Input/output error
 acoustic      = not supported

Is there any patch flying around that already enables this or even any
ETA in the current mainstream?

Thanks!
Soeren

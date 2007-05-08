Return-Path: <linux-kernel-owner+w=401wt.eu-S967253AbXEHNhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967253AbXEHNhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966951AbXEHNhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:37:53 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:37707 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966854AbXEHNhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:37:52 -0400
Date: Tue, 8 May 2007 15:37:13 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg K-H <greg@kroah.com>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As I wanted to add multithreaded probing for some s390 busses, I
discovered that the commit above removed the multithreaded probing
infrastructure again, while just some days before some of my patches
reworking it had been merged... I thought
http://marc.info/?l=linux-kernel&m=117591868412593&w=2 meant that we
should go ahead with per-subsystem multithreaded probing?

(OK, PCI_MULTITHREAD_PROBE should not depend on BROKEN, but on
EXPERIMENTAL with the reworked probing infrastructure. This got mixed
up, I can send a patch that changes it.)

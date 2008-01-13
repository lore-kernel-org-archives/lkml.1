Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYAMUZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYAMUZo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 15:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYAMUWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 15:22:37 -0500
Received: from smtp108.plus.mail.re1.yahoo.com ([69.147.102.71]:32340 "HELO
	smtp108.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753903AbYAMUWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 15:22:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer;
  b=3lSoVjfl+SQKjOFfhJkdD0SSORycR5WAvGErFvr6QYxraYlbNmV5DKVNGQD8cPrMVyA6kbVKMfH36RooJ3NyFcd8F3DrcuggUrhxXbAV5yiIe3QmupejX5FbJwI3H2h9zruEv3Rd9scvoO0nRBpSSnjqHWV3y/rhr0FhelPIcF8=  ;
X-YMail-OSG: qHEfepwVM1nVGS0Kz.IxN7PRjYdBPVJNQc.UatMiX.XdavWl
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 0/12] ide-floppy redux v2.5
Date: Sun, 13 Jan 2008 21:18:13 +0100
Message-Id: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here are the remaining patches which had issues to be worked out. I decided
to keep the Flexible Disk Page and Capacity Descriptor in
idefloppy_floppy_t for the sake of the two printk calls for which they are
used. Otherwise, we'll be changing long-known driver behavior and this won't
be acceptable. I'll audit the driver to see whether rq_data_dir() can replace
the PC_WRITING flag completely and get rid of that one too.

By the way, I have an Iomega ZIP 100 drive somewhere in my hardware pile and
will do some testing with the "new" :) driver just in case.


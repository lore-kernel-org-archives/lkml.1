Return-Path: <linux-kernel-owner+w=401wt.eu-S1759634AbZFBHFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbZFBHFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758706AbZFBHFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:05:13 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:47592 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011AbZFBHFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:05:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cwSYBT0i/SgxDKbulsoQh+JgdxEL77lFgtgmoj1j0B+tzts0yj2gAO8HU++iGBip1V
         LoIMrLujhAlr/DANzzGTjTKWbp+FcfB9+j4KPYm2iZB3ntKxwHjbUsvyy18lvv/UKomE
         bPRjhqDT57pl546E3x2pR2zqrAjWPAwFTbWZM=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ide-tape: fix flags
Date: Tue,  2 Jun 2009 09:05:06 +0200
Message-Id: <1243926308-32385-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3.1
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

those fix a stupid flags misuse that got spotted by Jiri Slaby. Please
pay special attention to the first patch. FWIW, those can go as hot
fixes right away and we might catch 30-rc8 since it's not out yet.

Thanks,
Boris.

drivers/ide/ide-atapi.c |    2 +-
 drivers/ide/ide-tape.c  |   64 ++++++++++++++++++++++++++++++----------------
 2 files changed, 43 insertions(+), 23 deletions(-)

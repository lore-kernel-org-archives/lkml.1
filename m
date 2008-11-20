Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYKTFl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYKTFl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 00:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbYKTFlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 00:41:25 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:34263 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbYKTFlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 00:41:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:date:message-id:x-mailer:from;
        b=v8pU5gz85wpZojAgibY6vs6YHEGgvyhsvJqjdbJS1s7f8atSRlU3ktq+L4lbMHQ3h1
         mMbd9NG60NhMkzpw1gjjTZunpETfWNQK5dvPnJyi9U5uyu7eRbKExujp0ZeoPrH6ubrj
         sysg5Puidqk2EhfJckrXECc1k6mxEnr7Ky3bQ=
To: <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 00/03] ide misc leftovers
Date: Thu, 20 Nov 2008 06:41:20 +0100
Message-Id: <1227159683-2487-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.3
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here is Linus' reworked ide-floppy reduce-stack-usage patch. It has been tested
here on current pata tree with your latest 3 patches adding the per-device
request queue locks. Along with that are 2 small cleanups.


 drivers/ide/ide-cd.c           |    8 +++++
 drivers/ide/ide-cd.h           |    8 -----
 drivers/ide/ide-floppy.c       |   26 +++++++++---------
 drivers/ide/ide-floppy_ioctl.c |   58 +++++++++++++++++++--------------------
 include/linux/ide.h            |   48 ++++++++++++++++----------------
 5 files changed, 73 insertions(+), 75 deletions(-)

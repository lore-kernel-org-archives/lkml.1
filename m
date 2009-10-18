Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZJRWy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZJRWy7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZJRWy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:54:58 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48907 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZJRWy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:54:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=TlZhI8oGualK3vylPY4EBI1MzQ6zh+Wh5SxBj6PQH+bYerTav/Lrur8aPaz7AE9sCA
         trfq6jVrbJbgaTsThHR7RWF5NckkUsUKMnUVAVpY68izUoiSZVZkE+1h953lZAHEt1kU
         gHbj4wxwOl5Yj2HJ/NfZyEHSnIFv1M1pa4gz8=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org,
       Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 0/7] trivial: fix some compilation warnings for 2.6.32-rc5
Date: Mon, 19 Oct 2009 01:54:27 +0300
Message-Id: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These fixes almost all the warnings I get while compiling a custom kernel for
my laptop.

I'm not so sure about adding __cpuinit to acpi_processor_add() but otherwise
these should be safe to apply.

Felipe Contreras (7):
  usb: trivial cleanups
  ipc: fix trivial warning
  crypto: testmgr: fix warning
  acpi: processor: fix section mismatch
  acpi: fix a bunch of style issues on 'actypes.h'
  acpi: fix trivial warning
  acpi: fix trivial warnings caused by previous commmit

 crypto/testmgr.c              |    2 +-
 drivers/acpi/acpica/exfldio.c |    8 ++++----
 drivers/acpi/processor_core.c |    2 +-
 drivers/usb/core/hcd.c        |    7 +++----
 include/acpi/actypes.h        |   36 ++++++++++++++++++------------------
 ipc/msg.c                     |    2 +-
 6 files changed, 28 insertions(+), 29 deletions(-)


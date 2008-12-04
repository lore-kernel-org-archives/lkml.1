Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbYLDGok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbYLDGok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbYLDGnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:43:42 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:58967 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbYLDGni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:43:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=MmZN6iB7YQPTdXgohr/U2ocbickRGga417fy1gWg53v9XlXhAxhD/kqlYAHj3XbNEu
         Tlm5gJSl+2b8ySafgCnTvn4js3a4KmkoAdrynzOyAb0hAAAo0Lm7gX5a38O/CYFdpABa
         Zl0/D7qltGqNdetW1wYTGmHXkkVXeB+cdRoPc=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 00/06] ide-atapi: more leftovers
Date: Thu,  4 Dec 2008 07:43:23 +0100
Message-Id: <1228373010-20249-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.3
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here are the reworked patches of the first batch of ide-cd to generic
conversion. They've been lightly tested with ide-floppy only since the
ide-cd is still needs rewiring after all is moved to ide-atapi.

 drivers/ide/ide-atapi.c  |   94 +++++++++++++++++++++++++++++++++++++--------
 drivers/ide/ide-cd.c     |   42 ++------------------
 drivers/ide/ide-cd.h     |    1 -
 drivers/ide/ide-floppy.c |    2 +-
 drivers/ide/ide-tape.c   |    2 +-
 drivers/scsi/ide-scsi.c  |    2 +-
 include/linux/ide.h      |    7 ++-
 7 files changed, 90 insertions(+), 60 deletions(-)

-- 
Regards/Gruss,
    Boris.

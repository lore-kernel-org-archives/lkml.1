Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668Ab0AQU7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0AQU7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 15:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611Ab0AQU7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 15:59:52 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:48733 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab0AQU7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 15:59:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=ucVcRAThEd5NBUJ4jQIYjAtkKx379fqJ5jGn1S+WmWRvrfPbqPFT78ySAU9MSfaaPw
         cL8FYl7jB/oFBIr4vL44WokwbNvRPcIlNgr/nX28G9DphEDQ4W9H2wLp8JTnqkbfvMH6
         waxR4eGaZAGdwuRXARtSzMvxQtsfcXkuWnjyY=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH 0/2] Fix recently introduced strnstr() to not search past NUL
Date: Sat, 16 Jan 2010 18:56:59 -0200
Message-Id: <cover.1263675077.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.6.201.g56119
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also simplify stricmp(), so that we do not increase lib/string.o code size.

André Goddard Rosa (2):
  string: simplify stricmp()
  string: teach strnstr() to not search past NUL-terminator

 lib/string.c |   38 ++++++++++++++++++--------------------
 1 files changed, 18 insertions(+), 20 deletions(-)


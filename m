Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbZIVOyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbZIVOyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbZIVOyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:54:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:49566 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490AbZIVOyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:54:52 -0400
Subject: [PATCH] STAGING: includecheck fix: iio, lis3l02dqbuffersimple.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Greg KH <greg@kroah.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Jonathan Cameron <jic23@cam.ac.uk>, devel@driverdev.osuosl.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 20:24:46 +0530
Message-Id: <1253631286.3784.31.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c: dirent.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 .../iio/Documentation/lis3l02dqbuffersimple.c      |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c b/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
index 2b5cfc5..6a8fa0c 100644
--- a/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
+++ b/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
@@ -19,7 +19,6 @@
 #include <sys/dir.h>
 
 #include <linux/types.h>
-#include <dirent.h>
 #include "iio_util.h"
 
 static const char *ring_access = "/dev/iio/lis3l02dq_ring_access";
-- 
1.6.0.6



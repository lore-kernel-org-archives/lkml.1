Return-Path: <linux-kernel-owner+w=401wt.eu-S934850AbYAaXTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934850AbYAaXTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 18:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbYAaXS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 18:18:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:38594 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYAaXS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:18:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=aqA4nHf90aNmMV5gyCQCt54rNtskY2PJAx5mYK2bddRGC1Kmq4FyeQDEwnCpBAUikpbaA67S8KNwT/RsJNtVmoSZ6ABnU4hKnvIX5UDfmu3m2CuhAT4/bHbrB/6b8q6YZB1SorfudqYthXC6XZHn8y1av4q8VMiZgyBxoOt3ILs=
From: Mike Frysinger <vapier.adi@gmail.com>
Organization: ADI
To: Andrew Morton <akpm@osdl.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: [patch] cleanup rtc example code
Date: Thu, 31 Jan 2008 18:18:46 -0500
User-Agent: KMail/1.9.7
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801311818.46674.vapier.adi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes here, just tighten up style/whitespace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
index e20b19c..8deffcd 100644
--- a/Documentation/rtc.txt
+++ b/Documentation/rtc.txt
@@ -268,8 +268,8 @@ int main(int argc, char **argv)
 		/* This read will block */
 		retval = read(fd, &data, sizeof(unsigned long));
 		if (retval == -1) {
-		        perror("read");
-		        exit(errno);
+			perror("read");
+			exit(errno);
 		}
 		fprintf(stderr, " %d",i);
 		fflush(stderr);
@@ -326,11 +326,11 @@ test_READ:
 		rtc_tm.tm_sec %= 60;
 		rtc_tm.tm_min++;
 	}
-	if  (rtc_tm.tm_min == 60) {
+	if (rtc_tm.tm_min == 60) {
 		rtc_tm.tm_min = 0;
 		rtc_tm.tm_hour++;
 	}
-	if  (rtc_tm.tm_hour == 24)
+	if (rtc_tm.tm_hour == 24)
 		rtc_tm.tm_hour = 0;
 
 	retval = ioctl(fd, RTC_ALM_SET, &rtc_tm);
@@ -407,8 +407,8 @@ test_PIE:
 					"\n...Periodic IRQ rate is fixed\n");
 				goto done;
 			}
-		        perror("RTC_IRQP_SET ioctl");
-		        exit(errno);
+			perror("RTC_IRQP_SET ioctl");
+			exit(errno);
 		}
 
 		fprintf(stderr, "\n%ldHz:\t", tmp);
@@ -417,27 +417,27 @@ test_PIE:
 		/* Enable periodic interrupts */
 		retval = ioctl(fd, RTC_PIE_ON, 0);
 		if (retval == -1) {
-		        perror("RTC_PIE_ON ioctl");
-		        exit(errno);
+			perror("RTC_PIE_ON ioctl");
+			exit(errno);
 		}
 
 		for (i=1; i<21; i++) {
-		        /* This blocks */
-		        retval = read(fd, &data, sizeof(unsigned long));
-		        if (retval == -1) {
-				       perror("read");
-				       exit(errno);
-		        }
-		        fprintf(stderr, " %d",i);
-		        fflush(stderr);
-		        irqcount++;
+			/* This blocks */
+			retval = read(fd, &data, sizeof(unsigned long));
+			if (retval == -1) {
+				perror("read");
+				exit(errno);
+			}
+			fprintf(stderr, " %d",i);
+			fflush(stderr);
+			irqcount++;
 		}
 
 		/* Disable periodic interrupts */
 		retval = ioctl(fd, RTC_PIE_OFF, 0);
 		if (retval == -1) {
-		        perror("RTC_PIE_OFF ioctl");
-		        exit(errno);
+			perror("RTC_PIE_OFF ioctl");
+			exit(errno);
 		}
 	}
 

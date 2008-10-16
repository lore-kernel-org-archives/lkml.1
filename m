Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYJPPCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYJPPCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbYJPPBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:01:53 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:37533 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbYJPPBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:01:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fZacGGyyXvDhXs6vLjYnN7IIW0FAGLbl/lXkKLNOTib701MH6EfJUuvYv3Y4qZbogK
         aP3e0qmXoHTvQKQq055UqEkO3jK32chp1TdyVOAcE/qx7cRCn02UZzaesFaQUxEx7PcD
         hS0vd8r5Qbrv3A+/yScvZS1CRWMXdT4/udOFk=
From: Yauhen Kharuzhy <jekhor@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Yauhen Kharuzhy <jekhor@gmail.com>
Subject: [PATCH] rtc-s3c: Fix section mismatch warnings
Date: Thu, 16 Oct 2008 18:01:41 +0300
Message-Id: <1224169301-18018-1-git-send-email-jekhor@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warnings was appeared when compile rtc-s3c.c because
platform_driver structure s3c2410_rtcdrv has wrong name.

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>

-- 
1.5.6.5


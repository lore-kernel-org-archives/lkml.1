Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbZGaG2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbZGaG2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 02:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZGaG2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 02:28:33 -0400
Received: from n57.bullet.mail.sp1.yahoo.com ([98.136.44.49]:30080 "HELO
	n57.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751089AbZGaG2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 02:28:32 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jul 2009 02:28:32 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 494069.16551.bm@omp102.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=nRhhZ/9+ThtuO+usPybJZI2Tv0sKICTrWM58BDIzYchWx71dZW0SYjQv0iKf1uYVv446nnzNIypzUZIp4S72/vMWgQMGzrjgHl/XPUUi5FQtRFBAbTjIsI2PKSNJnK5TkGZklfBNnvq+hYbyZIO3DxG0ZxWxLsXAVjD2vjYdKw4=;
Message-ID: <937390.49428.qm@web111003.mail.gq1.yahoo.com>
X-YMail-OSG: lDue6qoVM1kM_CF._KqiwUS84nDrvi7YERnxdqz_g9m2e7xbb8Y0wd0Y3tucPFh7NJR2J1N40x1EqmbGySthTJ1ddwdeAdOXgWfepkUT0UV.E1pIcnm8zv4maOxt7WgWTfv.xG67CwOR1zmCddwnPQs8bd4jPjFnL_ixUyBur6g5tdXq0_zIsO6FC7m66rYEWJnlVfIhMaNl_gHWL1Z1IshcHDZjWnIbE7o5hzcna7BT9dsHXnLboImqj6K7GBJD4DOgOqRCjQrp1Cip0A--
X-Mailer: YahooMailClassic/6.0.19 YahooMailWebService/0.7.338.2
Date: Thu, 30 Jul 2009 23:22:31 -0700 (PDT)
From: Andrew Watts <akwatts@ymail.com>
Subject: Bug report (suspend to disk is broken in 2.6.29+ with EIDE drive)
To: linux-kernel@vger.kernel.org
Cc: akwatts@ymail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Description: s2disk worked in 2.6.28 and no longer works in 2.6.30.2
(s2disk here means: echo disk > /sys/power/state); screen blanks but
system hangs.

Bisection reveals that the problem commit has hash:
295f00042aaf6b553b5f37348f89bab463d4a469.

~Andy

PS I wrote some months ago about a thermal problem on my HW with
2.6.28 (needed noapic, nolapic to have it not run hot @ idle).
This problem has disappeared in 2.6.30.2. Any devs have an idea what
commit fixed this?


      


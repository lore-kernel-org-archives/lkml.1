Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYAQKsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYAQKsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 05:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYAQKsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 05:48:11 -0500
Received: from web52003.mail.re2.yahoo.com ([206.190.49.250]:28461 "HELO
	web52003.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751588AbYAQKsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 05:48:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=Gacf1tIsboUZTGQKmjBQBZJjl1wsAR2k5s23RuYt7oRQxEMCC9iJTM3wBDM3cmmEzE2Z2o7PtGZ/gZ57C2OZsRUcYuKII6hHdmPxL+UX2/fEFGbodqkDlFu2fMjptFEOFSGekCP2RtV7EWIF9u2wgV2OsoT+jR5q18MKCZtugJ8=;
X-YMail-OSG: 6BOvOQYVM1lPmjCItiS8GcGZljw9r4RwAeVeVLVO78DxKQxwVVPS8K6q13fHxNXNyYQsMDmzW6NE5nBD_qX67gwiVJqAZC.BKKhU2lUxFnA_r3htgAQ-
X-Mailer: YahooMailRC/818.31 YahooMailWebService/0.7.160
Date: Thu, 17 Jan 2008 02:48:08 -0800 (PST)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: PIT clocksource makes invalid assumptions
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <823179.48268.qm@web52003.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought the following bug might be caused by PIT:
ifconfig eth1 showed UP and RUNNING even though traffic did not work.

The following lines in dmesg look suspicious:
[   83.017954] Clocksource tsc unstable (delta = 111864067 ns)
[   83.018930] Time: pit clocksource has been installed.
http://bugzilla.kernel.org/show_bug.cgi?id=9336




      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs

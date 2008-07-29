Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbYG2Ppn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbYG2Ppn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbYG2PoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:44:22 -0400
Received: from bay0-omc3-s3.bay0.hotmail.com ([65.54.246.203]:26934 "EHLO
	bay0-omc3-s3.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755393AbYG2PoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:44:21 -0400
Message-ID: <BAY103-DAV4F0ECBCAFB86B24C87D3EB2820@phx.gbl>
X-Originating-IP: [85.32.103.134]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: commit a29ccf6f823a84d89e1c7aaaf221cf7282022024 break console on slackware 12.1
Date: Tue, 29 Jul 2008 17:42:54 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 29 Jul 2008 15:44:20.0334 (UTC) FILETIME=[F76718E0:01C8F191]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

reverting commit a29ccf6f823a84d89e1c7aaaf221cf7282022024
fix a problem with the text console on slackware 12.1

With 2.6.27-rc1/slackware 12.1, applications like
mc or 'make menuconfig' are broken on text console
(they are fine running inside an xterm).

Just for record: 2.6.26 is fine

a29ccf6f823a84d89e1c7aaaf221cf7282022024 is first bad commit
commit a29ccf6f823a84d89e1c7aaaf221cf7282022024
Author: David Woodhouse <dwmw2@infradead.org>
Date:   Tue Jun 3 14:59:40 2008 +0100

    Make console charset translation optional

    By turning off the new CONSOLE_TRANSLATIONS option and dropping the
    associated code and tables from the kernel, we can save about 7KiB.

    Taken from linux-tiny project by Tim Bird and mangled further by
dwmw2.

    Signed-off-by: Tim Bird <tim.bird@am.sony.com>
    Signed-off-by: David Woodhouse <dwmw2@infradead.org>

:040000 040000 4f86ab06f5af3f70d3b78c80ef60c38896c9bc1d
019444ec49f3251609c6e0b6046f2fb447f065e2 M      drivers
:040000 040000 e7149976d981052a6787c6e8207b6205ade0f1f1
591a26addee0ba619d7d878967664dfba86b4f65 M      include



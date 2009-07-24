Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbZGXQMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbZGXQMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZGXQMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:12:18 -0400
Received: from av8-2-sn3.vrr.skanova.net ([81.228.9.184]:41847 "EHLO
	av8-2-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbZGXQMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:12:15 -0400
Message-ID: <4A69DD57.6030405@mocean-labs.com>
Date: Fri, 24 Jul 2009 18:12:07 +0200
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: linux-input@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, kwangwoo.lee@gmail.com,
       Thierry Reding <thierry.reding@avionic-design.de>,
       Trilok Soni <soni.trilok@gmail.com>
Subject: [PATCH 0/2] tsc2007: controlled removal and reduced number of I2C
 transactions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two patches are supplied, booth are supposed to be applied against my 
previous ones, which are added to the -mm-tree.

The first one is proposed by Dmitry Torokhov, I have just made some 
changes so it applied to my previous changes, and I tried it out.

The second one decreases the number of I2C transactions transferred by 
the driver. A unnecessary one during probe and an unnecessary power down 
during each poll for coordinates are removed. The chip is explicitly 
powered down before waiting for interrupts.

--Richard

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbZENSW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbZENSW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 14:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbZENSWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 14:22:18 -0400
Received: from www17.your-server.de ([213.133.104.17]:56020 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbZENSWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 14:22:17 -0400
Message-ID: <20090514202214.14243n1debrzobx2@mail.your-server.de>
Date: Thu, 14 May 2009 20:22:14 +0200
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Subject: oprofile: WQ on CPU0, prefer CPU1
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.2)
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After suspend and resume to/from S3 I see a lot of these messages in  
the kernel log:

[11750.054031] WQ on CPU0, prefer CPU1
[11750.154023] WQ on CPU0, prefer CPU1
[11750.254022] WQ on CPU0, prefer CPU1
[11750.354022] WQ on CPU0, prefer CPU1
[11750.454018] WQ on CPU0, prefer CPU1
[11750.554022] WQ on CPU0, prefer CPU1
[11750.654022] WQ on CPU0, prefer CPU1
[11750.754039] WQ on CPU0, prefer CPU1
[11750.854020] WQ on CPU0, prefer CPU1
[11750.954024] WQ on CPU0, prefer CPU1
[11751.054029] WQ on CPU0, prefer CPU1
[11751.154028] WQ on CPU0, prefer CPU1
[11751.254026] WQ on CPU0, prefer CPU1
[11751.354019] WQ on CPU0, prefer CPU1
[11751.454022] WQ on CPU0, prefer CPU1
[11751.554032] WQ on CPU0, prefer CPU1
[11751.654028] WQ on CPU0, prefer CPU1
[11751.754028] WQ on CPU0, prefer CPU1
[11751.854033] WQ on CPU0, prefer CPU1
[11751.954029] WQ on CPU0, prefer CPU1
[and so on; seems not to stop]

This comes from drivers/oprofile/cpu_buffer.c

Bug or feature?

greets
thomas

PS: 2.6.30-rc5



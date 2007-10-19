Return-Path: <linux-kernel-owner+w=401wt.eu-S967935AbXJSWAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967935AbXJSWAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967682AbXJSWAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:00:16 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:42961 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966875AbXJSWAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:00:13 -0400
Message-Id: <20071019215538.395133000@linux.vnet.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Oct 2007 23:55:38 +0200
From: Ursula Braun <braunu@de.ibm.com>
To: jgarzik@pobox.com, netdev@vger.kernel.org, linux-s390@vger.kernel.org
Cc: mschwid2@linux.vnet.ibm.com, apw@shadowen.org,
       linux-kernel@vger.kernel.org, kamalesh@linux.vnet.ibm.com,
       kaber@trash.net
Subject: [patch 0/1] remove header_ops bug in qeth driver
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
Remove qeth driver bug introduced by this commit:

commit 3b04ddde02cf1b6f14f2697da5c20eca5715017f
Author: Stephen Hemminger <shemminger@linux-foundation.org>
Date:   Tue Oct 9 01:40:57 2007 -0700

    [NET]: Move hardware header operations out of netdevice.


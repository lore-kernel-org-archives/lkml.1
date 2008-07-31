Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYGaMlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYGaMlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbYGaMkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:40:37 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:48899 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbYGaMkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:40:36 -0400
Message-Id: <20080731123004.868574766@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 31 Jul 2008 14:30:04 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 0/6] latest bug fixes for s390.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
just a couple of additional bug fixes for 2.6.27-rc1. The only
one which is remotely interesting is the diag 0x260 removal.
The memory detection code stops using it anymore because there
are situations where the value you get from it just isn't usable.
I'll add them to git390 for the next please pull.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


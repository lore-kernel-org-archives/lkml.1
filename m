Return-Path: <linux-kernel-owner+w=401wt.eu-S1030361AbXC2Qjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030361AbXC2Qjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 12:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030360AbXC2Qjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 12:39:36 -0400
Received: from keil-draco.com ([216.193.185.50]:50604 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030344AbXC2Qjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 12:39:35 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: linux-kernel@vger.kernel.org
Subject: apm platform device cleanup
Date: Thu, 29 Mar 2007 12:39:22 -0400
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703291239.23073.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In checking a "make allmodconfig" I noticed that the apm device 
(arch/i386/kernel/apm.c) is still using the old pm_send_all setup - I know 
the fix is to add suspend/resume hooks but the apm code hasn't been touched 
since 2002 and isn't using the new device API (it doesn't even register, 
AFAICT, a platform_device struct) Beyond needing to add that, are there any 
suggestions ?

DRH

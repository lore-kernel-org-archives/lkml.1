Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYDCMbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYDCMbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 08:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYDCMbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 08:31:32 -0400
Received: from mail0.scram.de ([78.47.204.202]:40932 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbYDCMbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 08:31:32 -0400
X-Spam-Score: -4.21
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <47F4CE11.1090607@scram.de>
Date: Thu, 03 Apr 2008 14:31:13 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Laurent Pinchart <laurentp@cse-semaphore.com>
CC: linuxppc-dev@ozlabs.org, Scott Wood <scottwood@freescale.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] CPM1: implement GPIO LIB API
References: <47E92EC8.7010700@scram.de> <200804031319.12715.laurentp@cse-semaphore.com>
In-Reply-To: <200804031319.12715.laurentp@cse-semaphore.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

> I haven't checked all CPM1-based parts, but for the MPC855 family this doesn't 
> look right. The MPC855 has two 32-bit ports, port B and port E. Registers for 
> port B are dir, par, odr and dat, and registers for port E are dir, par, sor, 
> odr and dat.

You probably mean MPC885. Thanks for catching this, the 32bit registers really
are a mess on CPM1 platforms.

> Are you working on a similar patch for the CPM2 ? CPM2 I/O ports are 32 bit 
> wide and their registers are layed out like for port E on the MPC855. It 
> should thus be possible to share code between CPM1 and CPM2.

Yes, some common port setup code could probably be moved to cpm.c.

Thanks,
Jochen

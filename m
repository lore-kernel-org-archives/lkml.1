Return-Path: <linux-kernel-owner+w=401wt.eu-S1765521AbYARTG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765521AbYARTG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbYARTGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:06:52 -0500
Received: from etm005.nl.ded.neolocation.net ([85.17.111.100]:55878 "EHLO
	office.one.by" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752604AbYARTGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:06:51 -0500
MIME-Version: 1.0
Date: Fri, 18 Jan 2008 21:06:43 +0200
From: Chodorenko Michail <misha@one.by>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Celeron Core
Message-ID: <3ed23423adebae08e8f75b6a6a7ce7ff@one.by>
User-Agent: RoundCube Webmail on office.one.by
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a laptop "Extensa 5220", with the processor Celeron based on 'core'
technology.
There is ~ / arch/i386/kernel/cpu/cpufreq/p4-clockmod.c in the kernel
source code
but there's no line identification of my CPU for apply freqency change
need to add a ID line 0х16
                       
 
    "that instead of p4-clockmod, if possible.\n");
               switch (c->x86_model) {
               case 0x0E: /* Core */
+              case 0x16: /* Celeron Core */
               case 0x0F: /* Core Duo */
                      p4clockmod_driver.flags |= CPUFREQ_CONST_LOOPS;
                      return
speedstep_get_processor_frequency(SPEEDSTEP_PROCESSOR_PCORE);




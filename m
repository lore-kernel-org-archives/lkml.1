Return-Path: <linux-kernel-owner+w=401wt.eu-S936195AbYCTAzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936195AbYCTAzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYCTAzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:55:35 -0400
Received: from smtp-out2.libero.it ([212.52.84.42]:34519 "EHLO
	smtp-out2.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbYCTAze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:55:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjUBAP5S4UeXMW7J/2dsb2JhbAAIqjQ
User-Agent: Microsoft-Entourage/11.4.0.080122
Date: Thu, 20 Mar 2008 01:55:29 +0100
Subject: max_sectors_kb problem
From: Matteo Tescione <matteo@rmnet.it>
To: <linux-kernel@vger.kernel.org>
Message-ID: <C4077491.650A%matteo@rmnet.it>
Thread-Topic: max_sectors_kb problem
Thread-Index: AciKJRdWVfnuKvYYEdy6mAAZ4zZdpQ==
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Folks,

I'm running 2.6.24.3 kernel with the 3ware 9650se 8port in raid10 with 256K
of stripesize.
The question is: why linux kernel (2.6.24 but it's the same in older
kernels) see only 128K as it's max_sectors_kb ?
It's limited by max_hw_segments_kb which i think should be 256 with a 256 k
stripe.
It seems hardcoded somewhere, altough in 3w-9xxx.c i can't find it.
I'm running firmware FE9X 3.08.02.007 and driver version  2.26.02.010
Can someone help me?
Thanks in advance,
--
--
#Matteo Tescione
#RMnet srl



Return-Path: <linux-kernel-owner+w=401wt.eu-S1764304AbYBAMKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764304AbYBAMKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 07:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762954AbYBAMKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 07:10:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47275 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762908AbYBAMJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:09:59 -0500
Date: Fri, 1 Feb 2008 13:09:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Hans Verkuil <hverkuil@xs4all.nl>
Subject: [build bug] undefined reference to `i2c_attach_client'
Message-ID: <20080201120945.GA14632@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2353]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


randconfig testing found the following build bug in latest -git:

 drivers/built-in.o: In function `v4l2_i2c_attach':
 : undefined reference to `i2c_attach_client'

config attached.

	Ingo

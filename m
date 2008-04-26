Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYDZNZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYDZNZA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 09:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYDZNYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 09:24:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56604 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbYDZNYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 09:24:49 -0400
Date: Sat, 26 Apr 2008 15:24:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
Subject: [build bug] Re: [PATCH 00/37] Input queue for 2.6.26 merge window
Message-ID: <20080426132434.GA21423@elte.hu>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>   Input: xpad - add support for wireless xbox360 controllers

via the commit above (99de0912) a build bug sneaked in:

drivers/input/joystick/xpad.c: In function 'xpad_probe':
drivers/input/joystick/xpad.c:865: error: 'xpad_bulk_out' undeclared (first usein this function)
drivers/input/joystick/xpad.c:865: error: (Each undeclared identifier is reported only once
drivers/input/joystick/xpad.c:865: error: for each function it appears in.)

as found by randconfig testing:

  http://redhat.com/~mingo/misc/config-Sat_Apr_26_13_24_31_CEST_2008.bad

	Ingo

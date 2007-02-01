Return-Path: <linux-kernel-owner+w=401wt.eu-S1161198AbXBABVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161198AbXBABVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 20:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161199AbXBABVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 20:21:50 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:36512 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161198AbXBABVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 20:21:50 -0500
Date: Wed, 31 Jan 2007 17:21:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, dipankar@in.ibm.com, tytso@us.ibm.com,
       dvhltc@us.ibm.com, oleg@tv-sign.ru, twoerner.k@gmail.com,
       josh@freedesktop.org, billh@gnuppy.monkey.org,
       nielsen.esben@googlemail.com, corbet@lwn.net
Subject: [RFC PATCH -rt 0/2] RCU priority boosting that survives vicious testing
Message-ID: <20070201012136.GA21770@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This is yet another update of the RCU priority-boosting patch
(see http://lkml.org/lkml/2007/1/24/294 for the previous version).
This series contains the RCU-boost patch itself and rcutorture
modifications to test it more thoroughly.  This version incorporates
feedback from Josh Triplett and applies cleanly to 2.6.20-rc6-rt6.

						Thanx, Paul

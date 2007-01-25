Return-Path: <linux-kernel-owner+w=401wt.eu-S1751021AbXAYCLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021AbXAYCLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 21:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbXAYCLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 21:11:16 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:48464 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbXAYCLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 21:11:16 -0500
Date: Wed, 24 Jan 2007 18:11:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linuxtronix.de, dipankar@in.ibm.com, tytso@us.ibm.com,
       dvhltc@us.ibm.com, oleg@tv-sign.ru, twoerner.k@gmail.com,
       josh@freedesktop.org, billh@gnuppy.monkey.org,
       nielsen.esben@googlemail.com, corbet@lwn.net
Subject: [RFC PATCH -rt 0/2] RCU priority boosting that survives semi-vicious testing
Message-ID: <20070125021101.GA23428@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This is an update of the patch at http://lkml.org/lkml/2007/01/15/219.
This series contains (1) the RCU-boost patch itself and (2) some
rcutorture modifications to test it more thoroughly.  This version is
getting quite close.

There is still no OOM tie-in.  As before, dynamic adjustment of the
booster's priority will dynamically adjust the boostees.

						Thanx, Paul

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbZG2JAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbZG2JAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 05:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZG2JAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 05:00:42 -0400
Received: from aun.it.uu.se ([130.238.12.36]:55947 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbZG2JAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 05:00:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19056.4019.284852.926292@pilspetsen.it.uu.se>
Date: Wed, 29 Jul 2009 11:00:35 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.31-rc4 broke expect and gcc's testsuite
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lately I've been seeing many unexpected test case failures when
running gcc-4.4.1's test suite on one specific machine. The
gcc-4.4.1-RC's test suite worked fine on that machine a few weeks
ago, and gcc-4.4.1's works on two other machines, so this was a
bit of a puzzle.

Until I realised that the problematic machine is running 2.6.31-rc4,
and in the working cases all machines are or were running 2.6.30.

Rebooting into 2.6.30 on the problematic machine makes gcc's test
suite work on it again.

Preliminarily I have to suspect that the {p,t}ty changes break `expect'.

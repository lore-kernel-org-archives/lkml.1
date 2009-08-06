Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbZHGAsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbZHGAsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 20:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbZHGAsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 20:48:18 -0400
Received: from vena.lwn.net ([206.168.112.25]:40281 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbZHGAsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 20:48:18 -0400
Date: Thu, 6 Aug 2009 13:58:41 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mark Gross <mgross@linux.intel.com>
Subject: [PATCH 0/2] pm_qos: BKL removal and cleanup
Message-ID: <20090806135841.46682114@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a pair of patches which removes the BKL from
kernel/pm_qos_params.c and cleans up a minor (but real) race problem I
found therein.

I retired my bkl-removal tree; Ingo, assuming all's well here, can this
hang out in your kill-bkl tree until the merge window opens?

Thanks,

jon

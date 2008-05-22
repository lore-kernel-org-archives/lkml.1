Return-Path: <linux-kernel-owner+w=401wt.eu-S1759650AbYEVUga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbYEVUga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbYEVUgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:36:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54643 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755319AbYEVUgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:36:19 -0400
Date: Thu, 22 May 2008 21:23:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Subject: [PATCH] apm_emu: push BKL down into ioctl handlers
Message-ID: <20080522212341.6527256c@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the elimination of the old lock based ioctl. This one can
probably lose the remaining BKL pretty trivially

Signed-off-by: Alan Cox <alan@redhat.com>

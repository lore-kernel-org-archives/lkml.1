Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbZGOKO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbZGOKO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 06:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZGOKO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 06:14:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38053 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751224AbZGOKO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 06:14:27 -0400
Date: Wed, 15 Jul 2009 11:15:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: REVERT request: a6540f731d506d9e82444cf0020e716613d4c46c
Message-ID: <20090715111509.453c1038@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus can you revert 

commit a6540f731d506d9e82444cf0020e716613d4c46c
Author: Alan Cox <alan@linux.intel.com>
Date:   Mon Jun 22 18:42:29 2009 +0100

    ppp: Fix throttling bugs
    


as requested before, as it was wrong, the pty code is now fixed and the
fact this isn't reverted is breaking pptp setups.

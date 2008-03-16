Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbYCPU45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbYCPU45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 16:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYCPU4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 16:56:49 -0400
Received: from [90.184.2.114] ([90.184.2.114]:20791 "EHLO mail.jaquet.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbYCPU4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 16:56:49 -0400
Date: Sun, 16 Mar 2008 21:56:47 +0100
From: Rasmus Andersen <rasmus@avlebavle.dk>
To: linux-kernel@vger.kernel.org
Subject: swap_dup and swap_free complaints on a swapless (2.6.24.2) system?
Message-ID: <20080316205647.GB7303@avlebavle.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have just found this in my logs on my 2.6.24.2

swap_dup: Bad swap file entry 00000067
VM: killing process sh
swap_free: Bad swap file entry 00000067
swap_free: Bad swap file entry 000000a1


The system is, for the time being, without swap and so I found this odd.
Could it be HW related? The box is presently syncing a 500GB raid1 set
in the background and so might be under more stress than usual. Or are
there other explanations for this?

Thanks,
  Rasmus

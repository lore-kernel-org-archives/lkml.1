Return-Path: <linux-kernel-owner+w=401wt.eu-S2993329AbXDTUV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993329AbXDTUV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993327AbXDTUV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:21:28 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:61904 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993331AbXDTUV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=EQNBUnw8xGoTs5wILrhAqtukcfneUG3R2CntNuvh/bwc0ffsYR9fdBubyouy8kmkziqAjkl+dvJhkJ1fPX4gpl8b6PDQddkzgkyL7z9nyPFtfuN8inTez+ZhGAYNOIvi71S4nwBLaE+CznrWt+Ejf7wNOn7a42yX9acHMxQ//lE=
Message-ID: <da612e190704201321o115e44eck570e716fd7869555@mail.gmail.com>
Date: Fri, 20 Apr 2007 22:21:26 +0200
From: "Mark Stier" <markstier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: FYI: Xen or kernel bug?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

tcp_vegas produces division by zero kernel oopses in dom0 when running
a Xen-patched 2.6.16.28 kernel. I have tracked down the problem to
line #256 in tcp_vegas.c: presumably due to flaky Xen timing, the rtt
seems to get zero from time to time (adding 1 to the rtt variable
solves the problem for me). The same should apply to line #140 in
tcp_veno.c, too.

Best regards,
Mark

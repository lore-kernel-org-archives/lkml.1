Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbYLUQhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbYLUQhb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 11:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYLUQhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 11:37:19 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:54788 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbYLUQhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 11:37:18 -0500
Message-ID: <494E586C.7070107@cfl.rr.com>
Date: Sun, 21 Dec 2008 09:53:32 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-kernel-rt <linux-rt-users@vger.kernel.org>
CC: Max Krasnyanskiy <maxk@qualcomm.com>
Subject: processor isolation inquiry
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been some time now since Max K. brought up the complete processor isolation
discussion. I know his original patch was NAK'd but some work on this was put
into cpusets. I'm unclear as to what actually has been or will be implemented.

The 2 things I'm most interested in are work queues, and local timer interrupts.
Is it yet possible to isolate a processor from either of these 2 things with
recent kernels?

The kernel doc concerning cpusets doesn't seem to clarify this for me.

The Process shielding instructions at

http://rt.wiki.kernel.org/index.php/CPU_shielding_using_/proc_and_/dev/cpuset

don't seem to help with work queues or local timer interrupts. Should they?

Thanks in advance for any pointers
Mark


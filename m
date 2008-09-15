Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbYIORB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbYIORB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYIORBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:01:22 -0400
Received: from main.gmane.org ([80.91.229.2]:57575 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbYIORBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:01:21 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Partition check considered as error is breaking mounting in 
  2.6.27
Date: Mon, 15 Sep 2008 13:01:09 -0400
Message-ID: <48CE94D5.7080305@tmr.com>
References: <bblSy-60j-19@gated-at.bofh.it> <bbnhC-7Vd-5@gated-at.bofh.it> <E1KeRMh-0001Ay-Uj@be1.7eggert.dyndns.org> <200809132025.40300.herton@mandriva.com.br> <Pine.LNX.4.58.0809141223300.16805@be10.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-71-245-142-197.albyny.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080716 Fedora/1.1.11-1.fc9 SeaMonkey/1.1.11
In-Reply-To: <Pine.LNX.4.58.0809141223300.16805@be10.lrz>
Cc: linux-usb@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:

> Ordinary users need a correctly-working, non-logspewing ("Access beyond
> end of disk") system, including the possibility to correctly create
> filesystems or to use md on the disks. Having an IO-error-area at the end
> of the partition won't exactly help, but maybe destroy the 
> HAL-automounted-using-the-wrong-options* filesystem.
> 
It's not clear that "ordinary users" ever have this problem. It seems to happen 
*only* when using a drive which has something which looks like a partition table 
but isn't, or is a defective partition table, or will only work when diddling 
with HPA magic.

And should some naive user be trying to use such a drive, it seems better to 
tell them, to beat them over the head with the problem, because if you hide the 
problem those users are least likely to be able to recover when problems arise.

I'm not against some sensible recovery, I just don't agree that "pretend it 
isn't wrong" is a good default solution.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot


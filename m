Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbYBRQcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbYBRQcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbYBRQc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:32:29 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3995 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963AbYBRQc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:32:28 -0500
Date: Mon, 18 Feb 2008 10:47:13 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Wael Nasreddine <mla@nasreddine.com>
Cc: LKML <linux-kernel@vger.kernel.org>, reinette.chatre@intel.com,
       yi.zhu@intel.com
Subject: Re: iwl3945 not working properly.
Message-ID: <20080218154713.GC3098@tuxdriver.com>
References: <20080218045425.GA7381@phoenix.nasreddine.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218045425.GA7381@phoenix.nasreddine.info>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 05:54:25AM +0100, Wael Nasreddine wrote:
> Hello,
> 
> I have a Toshiba Satellite A135-S4427 with and Intel 3945ABG card, the
> driver is not working properly.
> 
> When I turn on my PC it works fine, but If I ever bring the interface
> down, I no longer can associate it with any AP without rebooting, even
> the one I was using, I tried rmmod/modprobe iwl3945, didn't do
> anything,
> 
> iwconfig shows that the wlan0 has the radio turned off, and
> 
> $ cat /sys/bus/pci/drivers/iwl3945/0000:04:00.0/rf_kill
> 1
> 
> Even If I echo 0 > /sys/bus/pci/drivers/iwl3945/0000:04:00.0/rf_kill
> whenever I try to associate the interface with an AP it turns back to
> 1, I tried both iwconfig and NetworkManager, same problem.
> 
> There's a button on my laptop for Radio SoftKill (fn+F8) but it's not
> working, the soft kill is being enabled/disabled without my
> interference.
> 
> I tried it on kernel-2.6.24 and kernel-2.6.25-rc2 same result...
> 
> Any help is appreciated...
> 
> P.S: Please Cc to me, I am not subscribed to the mailing list.

This sounds similar to the bug here:

	https://bugzilla.redhat.com/show_bug.cgi?id=432264

The OP in that bug reports that the problem continues even after
reverting to older kernels that worked previously.

Hopefully part of the Intel crew will have some clue as to what is
happending here?

John
-- 
John W. Linville
linville@tuxdriver.com

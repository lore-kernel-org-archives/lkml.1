Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbYBEXKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbYBEXKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbYBEXKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:10:01 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56798 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755152AbYBEXKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:10:00 -0500
Date: Tue, 5 Feb 2008 23:59:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: ipw3945-devel@lists.sourceforge.net, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ipw3945: not only it periodically dies, it also BUG()s
Message-ID: <20080205225931.GA1031@elf.ucw.cz>
References: <20080205214441.GA1518@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205214441.GA1518@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-05 22:44:41, Pavel Machek wrote:
> Hi!
> 
> Under not-even-high load, it periodically restarts:
> 
> Feb  5 21:08:50 amd kernel: iwl3945: Microcode SW error detected.
> Restarting 0x82000008.
> Feb  5 21:08:52 amd kernel: iwl3945: Can't stop Rx DMA.
> Feb  5 21:12:51 amd kernel: iwl3945: Microcode SW error detected.
> Restarting 0x82000008.
> Feb  5 21:12:53 amd kernel: iwl3945: Can't stop Rx DMA.
> Feb  5 21:21:44 amd kernel: iwl3945: Microcode SW error detected.
> Restarting 0x82000008.
> Feb  5 21:21:46 amd kernel: iwl3945: Can't stop Rx DMA.
> Feb  5 21:27:32 amd kernel: iwl3945: Microcode SW error detected.
> Restarting 0x82000008.
> Feb  5 21:27:34 amd kernel: iwl3945: Can't stop Rx DMA.
> Feb  5 21:41:29 amd -- MARK --
> Feb  5 22:01:29 amd -- MARK --
> Feb  5 22:09:11 amd kernel: iwl3945: Microcode SW error detected.
> Restarting 0x82000008.
> Feb  5 22:09:12 amd kernel: iwl3945: Can't stop Rx DMA.
> 

Now it decided to be original:

Feb  5 23:55:39 amd kernel: ACPI: EC: missing write data confirmation,
don't expect it any longer.
Feb  5 23:57:37 amd kernel: iwl3945: Microcode SW error detected.
Restarting 0x82000008.
Feb  5 23:57:37 amd kernel: iwl3945: TODO:  Implement Tx ABORT
REQUIRED!!!
Feb  5 23:57:39 amd kernel: iwl3945: Can't stop Rx DMA.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

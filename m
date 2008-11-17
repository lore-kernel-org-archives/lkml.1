Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYKQCCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYKQCCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 21:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbYKQCCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 21:02:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:48095 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbYKQCCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 21:02:15 -0500
Message-ID: <4920D07C.40005@kernel.org>
Date: Mon, 17 Nov 2008 11:01:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Brad Campbell <brad@wasp.net.au>
CC: Mikael Pettersson <mikpe@it.uu.se>, Linda Walsh <lkml@tlinx.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       linux-ide@vger.kernel.org
Subject: Re: FYI: BUG in SATA Promise 300 TX4 (2.6.24 - 2.6.27-3) w/Linux
References: <491C9A4F.1020801@tlinx.org>	<491FB7E2.2030105@kernel.org> <18719.65298.689618.835202@harpo.it.uu.se> <49204EEA.8030605@wasp.net.au>
In-Reply-To: <49204EEA.8030605@wasp.net.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Nov 2008 02:01:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brad Campbell wrote:
>> The hardreset fix was included in 2.6.27.5. I wanted it in 2.6.26-stable
>> too, but that branch seems to have been closed now.
> 
> Is that likely to do anything for the old SATA150-TX4 ?
> I have 2 of them in a machine and I've been dropping drives under write
> load recently but it was a 2.6.27.4 kernel.
> 
> Reboot required to pick up the drives again (unless the kernel panics
> and it reboots itself - which it's been doing also).

Does unloading and reloading sata_promise fix the problem?  If your root
is on promise, you'll need to try this from usb stick or live CD.

-- 
tejun

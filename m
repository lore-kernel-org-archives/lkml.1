Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbYBDG7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbYBDG7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 01:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYBDG7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 01:59:31 -0500
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:43325 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbYBDG7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 01:59:30 -0500
Date: Sun, 3 Feb 2008 22:59:28 -0800
From: Robin Lee Powell <rlpowell@digitalkingdom.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Monthly md check == hung machine; how do I debug?
Message-ID: <20080204065928.GO12173@digitalkingdom.org>
References: <20080203212155.GF12173@digitalkingdom.org> <20080204053702.GA22183@lapse.madduck.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204053702.GA22183@lapse.madduck.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 06:37:02PM +1300, martin f krafft wrote:
> also sprach Robin Lee Powell <rlpowell@digitalkingdom.org> [2008.02.04.1021 +1300]:
> >     /usr/share/mdadm/checkarray --cron --all --quiet
> 
> FYI:
> http://git.debian.org/?p=pkg-mdadm/mdadm.git;a=blob;f=debian/checkarray
> 
> It basically does
> 
>   echo check > /sys/block/$array/md/sync_action
> 
> for all arrays.

Thanks for the clarification.

I've tried a few more times, by the way, and it seems that without
"mdadm --monitor" running, the hang doesn't occur.

I'd certainly prefer being notified of state changes, though, so
that's not much of a solution.

-Robin

-- 
Lojban Reason #17: http://en.wikipedia.org/wiki/Buffalo_buffalo
Proud Supporter of the Singularity Institute - http://singinst.org/
http://www.digitalkingdom.org/~rlpowell/ *** http://www.lojban.org/

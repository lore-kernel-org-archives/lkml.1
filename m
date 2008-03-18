Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYCRHmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYCRHmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 03:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbYCRHmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 03:42:06 -0400
Received: from c-67-188-67-135.hsd1.ca.comcast.net ([67.188.67.135]:46921 "EHLO
	freya" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750870AbYCRHmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 03:42:06 -0400
Date: Tue, 18 Mar 2008 00:41:58 -0700
From: "Adam J. Richter" <adam@yggdrasil.com>
To: "Adam J. Richter" <adam@yggdrasil.com>
Cc: tiwai@suse.de, pshou@realtek.com.tw, matt.jared@intel.com,
       andy.kopp@intel.com, dan.d.kogan@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: intel-hda sound too quiet in linux-2.6.25-rc6
Message-ID: <20080318074158.GA1924@freya.yggdrasil.com>
References: <20080318062359.GA19453@freya.yggdrasil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318062359.GA19453@freya.yggdrasil.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 11:23:59PM -0700, Adam J. Richter wrote:
>         I have a motherboard that uses the AMD am690g chip set,
> which has a sound hardware called "azalia", which apparently is
> controlled by linux/sound/pci/hda/hda_intel.c.
> 
> 	The audio works fine under linux-2.6.24.2.  However, in
> linux-2.6.25-rc3 (haven't tried earlier ones) through 2.6.25-rc6
> (released a couple of hours ago), the audio is barely audible unless I
> crank up my speakers to the maximum volume, at which point I can hear
> the music playing relatively quietly.  In comparison, if I were to do
> that with 2.6.24.2, it would wake the neighbors.  In both cases,
> this is with the volume set in aumix to 100 in both left and right
> (the maximum values).
> 
>         I haven't attempted to look through kernel changes from
> 2.6.24.2 to 2.5.25-rc3 yet, although I expect to over the weekend if
> nobody beats me to it.
> 
> Adam Richter

	I want to add the results of a few simple tests:

	1. Reverting only linux-2.6.25-rc6/sound/pci/hda/hda_intel.c to the
	   2.6.24.2 version had no effect (sound was still very quiet).

	2. Reverting linux-2.6.25-rc6/sound/pci/hda/*.[ch] to their
	   2.6.24.2 versions worked (i.e., sound was lound again).

	3. Other quick attempts at reverting various subsets of
 	   linux/sound/pci/hda/*.[ch] have resulted only in compilation
	   errors.


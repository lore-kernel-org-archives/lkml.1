Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbZICO70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbZICO70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbZICO7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:59:25 -0400
Received: from mail-pz0-f172.google.com ([209.85.222.172]:55764 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbZICO7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:59:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=vdrZlSqaADIi3IAZ1O4mOLDvBKpbfcK0SBTz8bPxbKHIJg7CDkzfYkI/rvdx55343U
         4hnTBGhWUUePXZIWN5rsTajIZpuiWaugBmbshALCWSQGcrIrBHATQNPeeUR2aGsC51TE
         aaErjMbf7LANYnFDvmWrZKqC0EAxGas0PPWJ0=
Date: Thu, 3 Sep 2009 07:59:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mario Limonciello <mario_limonciello@dell.com>
Subject: Re: Dell-laptop is not working without wireless
References: <20090818060340.E1C7A526EA5@mailhub.coreip.homeip.net> <20090818121049.GB22284@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818121049.GB22284@srcf.ucam.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090903153215.E51F8526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 01:10:49PM +0100, Matthew Garrett wrote:
> On Mon, Aug 17, 2009 at 10:32:27PM -0700, Dmitry Torokhov wrote:
> 
> > dell-laptop module does not work on my Latitude d630 unless driver for
> > my wireless card (which happens to be iwl3945) is already loaded.
> > Otherwise dcsbas_smi_request() returns all zeroes which causes
> > dell-laptop to not create any rfkill devices nor install backlight
> > device:
> 
> That's quite bizarre. I'd had one report of the backlight setup failing, 
> but hadn't connected it with wireless driver loading. Long shot, but I 
> don't suppose you can figure out which bit of the wifi config is needed 
> to get dell-laptop working by just bailing at various bits of the probe 
> and seeing if you get sensible answers?
> 

Admittedly I have not spend much time on it but it looks like my box
_really_ wants wifi interface to be fully operational before
dcsbas_smi_request() starts returning proper data. I wonder if iwl3945's
rfkill support interferes somehow here...

Maybe Mario (being a Dell guy) has an idea why this might be happening?

-- 
Dmitry

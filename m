Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbYACSoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbYACSoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 13:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYACSnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 13:43:50 -0500
Received: from ns.suse.de ([195.135.220.2]:42652 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbYACSnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 13:43:49 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Date: Thu, 3 Jan 2008 19:43:43 +0100
User-Agent: KMail/1.9.6
Cc: rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
References: <20080103442.621670000@suse.de> <20080103154229.9723F14DDD@wotan.suse.de> <20080103181438.GA7141@does.not.exist>
In-Reply-To: <20080103181438.GA7141@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031943.43828.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2008 19:14:38 Adrian Bunk wrote:
> On Thu, Jan 03, 2008 at 04:42:29PM +0100, Andi Kleen wrote:
> > 
> > This avoids the requirement to mark a lot of initialization functions not 
> > __cpuinit just for resume from RAM.
> > 
> > More functions could be converted now, didn't do all.
> >...
> 
> Shouldn't this aready be handled by the following?
> 
> config PM_SLEEP_SMP
>         bool
>         depends on SUSPEND_SMP_POSSIBLE || HIBERNATION_SMP_POSSIBLE
>         depends on PM_SLEEP
>         select HOTPLUG_CPU
>         default y

Won't help for UP at least. 

-Andi

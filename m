Return-Path: <linux-kernel-owner+w=401wt.eu-S1761592AbYCCXJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761592AbYCCXJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYCCXJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:09:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59988 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbYCCXJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:09:18 -0500
Date: Tue, 4 Mar 2008 00:10:33 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Andi Kleen <andi@firstfloor.org>, Lee Revell <rlrevell@joe-job.com>,
       linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080303231033.GB15255@one.firstfloor.org>
References: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com> <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 06:05:35PM -0500, Alan Stern wrote:
> On Mon, 3 Mar 2008, Pallipadi, Venkatesh wrote:
> 
> > But, with this patch:
> > - we are penalizing good hardware and making them less power efficient
> > to match the bad ones.
> > - There may also be server systems which first may not have these sort
> > of power fluctuations and even when buggy and have this noise, system
> > may be in some corner of some lab with fans making more noise than the
> > capacitors.
> 
> Can you make it configurable through sysfs?  

It already is, through a writable module_parm() 

> Default to disabled, but 
> allow the user to turn it on if the machine makes too much noise.

99+% of the users wouldn't be able to figure that out.

-Andi

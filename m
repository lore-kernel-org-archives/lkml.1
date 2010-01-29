Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673Ab0A2UBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0A2UBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011Ab0A2UBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:01:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44808 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab0A2UBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:01:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] PM / Runtime: Clean up pm_runtime_disable()
Date: Fri, 29 Jan 2010 21:01:45 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc5-rjw; KDE/4.3.5; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1001291435290.23361-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001291435290.23361-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001292101.45553.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 January 2010, Alan Stern wrote:
> On Fri, 29 Jan 2010, Rafael J. Wysocki wrote:
> 
> > On Friday 29 January 2010, Alan Stern wrote:
> > > On Thu, 28 Jan 2010, Rafael J. Wysocki wrote:
> > > 
> > > > > > - * If @check_resume is set and there's a resume request pending when
> > > > > > - * __pm_runtime_disable() is called and power.disable_depth is zero, the
> > > > > > - * function will wake up the device before disabling its run-time PM.
> > > > > >   */
> > > > > > -void __pm_runtime_disable(struct device *dev, bool check_resume)
> > > > > > +void pm_runtime_disable(struct device *dev)
> > > > > >  {
> > > > > 
> > > > > Why did you decide to remove the check_resume argument?  That decision 
> > > > > should be explained in the patch description.
> > > > 
> > > > Well, I thought the "which is not necessary any more" would be a sufficient
> > > > explanation ...
> > > 
> > > But why is it not necessary now,
> > 
> > Well, all of the existing callers use only one value of it, which is 'false'
> > (perhaps I should write that in the changelog).
> 
> I don't understand.  Isn't the existing version of pm_runtime_disable()
> a caller which sets check_resume to 'true'?  There certainly are places 
> that call pm_runtime_disable().

Sorry, you're absolutely right, so the patch is wrong.

Rafael

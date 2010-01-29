Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016Ab0A2Cao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab0A2Cao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 21:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530Ab0A2Can
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 21:30:43 -0500
Received: from netrider.rowland.org ([192.131.102.5]:45198 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752802Ab0A2Can (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 21:30:43 -0500
Date: Thu, 28 Jan 2010 21:30:40 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] PM / Runtime: Clean up pm_runtime_disable()
In-Reply-To: <201001282112.48214.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1001282129150.5247-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010, Rafael J. Wysocki wrote:

> > > - * If @check_resume is set and there's a resume request pending when
> > > - * __pm_runtime_disable() is called and power.disable_depth is zero, the
> > > - * function will wake up the device before disabling its run-time PM.
> > >   */
> > > -void __pm_runtime_disable(struct device *dev, bool check_resume)
> > > +void pm_runtime_disable(struct device *dev)
> > >  {
> > 
> > Why did you decide to remove the check_resume argument?  That decision 
> > should be explained in the patch description.
> 
> Well, I thought the "which is not necessary any more" would be a sufficient
> explanation ...

But why is it not necessary now, given that apparently it was necessary 
before?  What has changed to make it unnecessary?

Alan Stern


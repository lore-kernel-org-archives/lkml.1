Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbZBEJNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbZBEJNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 04:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758191AbZBEJMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 04:12:47 -0500
Received: from tundra.namei.org ([65.99.196.166]:3503 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757621AbZBEJMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 04:12:46 -0500
Date: Thu, 5 Feb 2009 20:12:36 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 0/7] integrity
In-Reply-To: <1233803196.3574.3.camel@localhost.localdomain>
Message-ID: <alpine.LRH.1.10.0902052010580.7359@tundra.namei.org>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com>  <alpine.LRH.1.10.0902051013430.4638@tundra.namei.org>  <1233794297.2962.7.camel@localhost.localdomain>  <alpine.LRH.1.10.0902051159560.5539@tundra.namei.org>
 <1233803196.3574.3.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Mimi Zohar wrote:

> On Thu, 2009-02-05 at 12:00 +1100, James Morris wrote:
> > On Wed, 4 Feb 2009, Mimi Zohar wrote:
> > 
> > > On Thu, 2009-02-05 at 10:16 +1100, James Morris wrote:
> > > > I get an oops on boot with this.
> > > > 
> > > > Do you have lock and list debugging enabled?
> > > 
> > > In the past I had them enabled.  Just recompiled now with them enabled
> > > and was able to boot without problems.
> > 
> > Do you have CONFIG_PREEMPT_RCU and SMP ?
> 
> I've recompiled with both CONFIG_PREEMPT_RCU and SMP and didn't
> get the oops.  Is your TPM enabled? 

It was disabled in bios, and the system boots ok with it enabled.

-- 
James Morris
<jmorris@namei.org>

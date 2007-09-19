Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbXISRaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbXISRaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758948AbXISR3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:29:47 -0400
Received: from mail.suse.de ([195.135.220.2]:39644 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756929AbXISR3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:29:45 -0400
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel Memory Ordering White Paper
References: <200709071526.51169.jesse.barnes@intel.com>
	<20070912182622.GA16520@gallifrey>
	<200709190926.55200.jesse.barnes@intel.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 19 Sep 2007 19:29:44 +0200
In-Reply-To: <200709190926.55200.jesse.barnes@intel.com>
Message-ID: <p73k5qmva0n.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jesse.barnes@intel.com> writes:
> 
> It's really both (1) and (2).  This document will become part of the 
> regular manuals when the next version is published.  And yes, 
> processors may do something different internally, but software can rely 
> on the behavior described by the rules in the document.

... until the first erratum comes around. With the multitude of x86
cores being introduced all the time (how many did only Intel just announce at 
IDF?@) that is going to happen sooner or later.

i386 with full legacy enabled already has to care about old PPros and 
those seriously violate write ordering.

-Andi

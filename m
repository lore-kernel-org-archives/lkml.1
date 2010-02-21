Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab0BUUfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 15:35:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58395 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab0BUUfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 15:35:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: What's the right value for idle= (was: Re: [linux-pm] regression on P-II SMP)
Date: Sun, 21 Feb 2010 21:36:03 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.64.1002212117540.9624@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1002212117540.9624@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002212136.03783.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 February 2010, Guennadi Liakhovetski wrote:
> Hi
> 
> my 2xP-II@400MHz locks up with 2.6.32(.X) unless I specify "idle=*" on the 
> kernel command-line, where "*" is one of "poll," "mwait," "halt," and only 
> "nomwait" indeed locks it up. Last kernel known to work was 2.6.25. So, it 
> doesn't bother me all that much - I have a way to boot it, but maybe 
> someone would be interested to fix this (this system already has a few 
> quirks on the kernel command line, so, one more doesn't really hurt;)). 
> What interests me more - which of those shall I be using? From 
> Documentation/kernel-parameters.txt it looks like "mwait" should be best 
> for me? Or should I be using "halt?" "Poll" does indeed fry CPUs - raises 
> sys temperatures to 50 / 60 degrees C. Power-saving is not that much of a 
> concern for me - I only run that system occasionally, but it shouldn't 
> produce more heat than it must;) And since this system does have a broken 
> ACPI (Compaq AP400), I wouldn't try to be too smart with it.

I guess "mwait" is the right one, but let's try to ask experts.

Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbYCUA1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbYCUA1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 20:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYCUA0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 20:26:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38128 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbYCUA0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 20:26:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 2)
Date: Fri, 21 Mar 2008 01:26:31 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <200803210101.04706.rjw@sisk.pl> <1206058863.16475.165.camel@johannes.berg>
In-Reply-To: <1206058863.16475.165.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803210126.32683.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 of March 2008, Johannes Berg wrote:
> 
> > + * All of the above callbacks, except for @complete(), return error codes.
> > + * However, the error codes returned by the resume operations, @resume(),
> > + * @thaw(), and @restore(), are only printed in the system logs, since the PM
> > + * core cannot do anything else about them.
> 
> Why bother and not just make them return void, the error printing can
> most likely be done much much better in the callback since that possibly
> has information on why it failed.
> 
> > + * All of the above callbacks, return error codes, but the error codes returned
> > + * by the resume operations, @resume_noirq(), @thaw_noirq(), and
> > + * @restore_noirq(), are only printed in the system logs, since the PM core
> > + * cannot do anything else about them.
> 
> Same here, of course.

The errors returned are used by TRACE_RESUME(), for example.

Well, perhaps the comments should be changed instead. :-)

Thanks,
Rafael

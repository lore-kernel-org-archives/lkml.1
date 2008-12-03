Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbYLCRnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbYLCRnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 12:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbYLCRnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 12:43:21 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:39651 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYLCRnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 12:43:20 -0500
Date: Wed, 3 Dec 2008 10:43:18 -0700
From: Alex Chiang <achiang@hp.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Trent Piepho <xyzzy@speakeasy.org>, "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       gregkh@suse.de
Subject: Re: Problems with fakephp
Message-ID: <20081203174318.GB26130@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Rolf Eike Beer <eike-kernel@sf-tec.de>,
	Trent Piepho <xyzzy@speakeasy.org>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-pci <linux-pci@vger.kernel.org>,
	Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de
References: <20081126074808.GE6539@plum> <Pine.LNX.4.58.0812021729560.2943@shell2.speakeasy.net> <20081203043804.GA26130@ldl.fc.hp.com> <200812031822.57197.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812031822.57197.eike-kernel@sf-tec.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rolf Eike Beer <eike-kernel@sf-tec.de>:
> Alex Chiang wrote:
> > I think the way forward is:
> >
> > 	- merge in the function level hotplug patch
> 
> Sorry that I don't get the point. To PCI Hotplug core or to fakephp?

I was talking about Trent's patch to add the "remove" attribute
to the pci-sysfs. Not fakephp.

> > 	- wholesale replacement of fakephp with new fakephp
> > 	- schedule new fakephp for deprecation
>                    ^^^
> 
> I don't think so.

If we get function level reset as part of the PCI core, then I
don't see what fakephp offers us anymore.

> > 	- encourage anyone who wants function level hotplug to
> > 	  use the 'remove' attribute
> >
> > Thoughts? Jesse, Willy, Eike, Greg?
> 
> Oh yes, let's start using dummyphp ;) That one already handled
> the rescan long ago. But I think it's a bit outdated at the
> moment, I haven't touched it for month. Looks like I need to
> bring it back to live.

I take it you are not impressed with my proposal? Care to explain why not?

/ac


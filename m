Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbYHLTxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbYHLTxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYHLTxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:53:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34357 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbYHLTxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:53:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60 (bisected)
Date: Tue, 12 Aug 2008 21:56:08 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       Milan Broz <mbroz@redhat.com>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Thomas Renninger <trenn@suse.de>
References: <20080806090246.GA1572@elf.ucw.cz> <20080812183004.GA24211@isilmar.linta.de> <20080812185941.GE1366@one.firstfloor.org>
In-Reply-To: <20080812185941.GE1366@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808122156.09850.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 of August 2008, Andi Kleen wrote:
> On Tue, Aug 12, 2008 at 08:30:04PM +0200, Dominik Brodowski wrote:
> > Hi,
> > 
> > On Tue, Aug 12, 2008 at 05:48:27PM +0200, Milan Broz wrote:
> > > -static unsigned int ignore_ppc = -1;
> > > +static int ignore_ppc = -1;
> > >  module_param(ignore_ppc, uint, 0644);
> > 			    ^^^^
> > follow-up change?
> 
> I'll fix it in the patch, thanks.

Is the complete patch available anywhere?  I need a link to it for the list of
regressions.

Thanks,
Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752913AbYHLS6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbYHLS6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 14:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbYHLS6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 14:58:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57681 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbYHLS6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 14:58:33 -0400
Date: Tue, 12 Aug 2008 20:59:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       Milan Broz <mbroz@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@suse.cz>, Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60 (bisected)
Message-ID: <20080812185941.GE1366@one.firstfloor.org>
References: <20080806090246.GA1572@elf.ucw.cz> <48A1779B.5020303@redhat.com> <20080812115530.GB8806@elf.ucw.cz> <200808121634.34634.rjw@sisk.pl> <48A1A4F6.9080706@redhat.com> <48A1B0CB.9050908@redhat.com> <20080812183004.GA24211@isilmar.linta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080812183004.GA24211@isilmar.linta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 08:30:04PM +0200, Dominik Brodowski wrote:
> Hi,
> 
> On Tue, Aug 12, 2008 at 05:48:27PM +0200, Milan Broz wrote:
> > -static unsigned int ignore_ppc = -1;
> > +static int ignore_ppc = -1;
> >  module_param(ignore_ppc, uint, 0644);
> 			    ^^^^
> follow-up change?

I'll fix it in the patch, thanks.

-Andi

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbZD0Rai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbZD0Rai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbZD0RaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:30:23 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:46825 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbZD0RaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:30:21 -0400
X-Loopcount0: from 143.166.82.43
Date: Mon, 27 Apr 2009 12:30:21 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Michael E Brown <Michael_E_Brown@dell.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Class device namespaces
Message-ID: <20090427173021.GA7078@auslistsprd01.us.dell.com>
References: <20090329174836.6de797d6@hyperion.delvare> <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com> <20090330104952.26f03c13@hyperion.delvare> <ac3eb2510903300424s2604d027h653a3f77163e0242@mail.gmail.com> <20090426085401.3788fc9c@hyperion.delvare> <20090426124443.GA12455@auslistsprd01.us.dell.com> <20090426130122.GB12455@auslistsprd01.us.dell.com> <20090427173005.3ff1100b@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427173005.3ff1100b@hyperion.delvare>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 05:30:05PM +0200, Jean Delvare wrote:
> On Sun, 26 Apr 2009 08:01:22 -0500, Matt Domsch wrote:
> > I'll note there is a second implementation that uses dell_rbu, and
> > that is included in each and every "Dell Update Package" (aka DUP)
> > BIOS update posted on support.dell.com for every Dell PowerEdge server
> > for the past several years.  Because the updater and they BIOS payload
> > are packaged in the same package, a change which would require
> > changing that updater will result in requiring Dell to spin and
> > re-release hundreds of DUPs, which would not go over well...  Thank
> > you for being careful not to change the interface capriciously - it
> > could have a huge impact on us.
> 
> I'll be careful, but you have to admit that duplicating utility code
> like this is poor engineering from Dell :( I don't want to think of the
> mess it will be if you ever have to fix a critical bug in that code.

Yes, this is well-understood, and steps are in process to address this
model.  http://linux.dell.com/firmware-tools is the preferred model,
with split inventory/execution components from firmware payloads.

Thanks,
Matt

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux

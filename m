Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbZDZNBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbZDZNBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 09:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbZDZNBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 09:01:24 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:47887 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbZDZNBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 09:01:23 -0400
X-Loopcount0: from 143.166.82.43
Date: Sun, 26 Apr 2009 08:01:22 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Michael E Brown <Michael_E_Brown@dell.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Class device namespaces
Message-ID: <20090426130122.GB12455@auslistsprd01.us.dell.com>
References: <20090329174836.6de797d6@hyperion.delvare> <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com> <20090330104952.26f03c13@hyperion.delvare> <ac3eb2510903300424s2604d027h653a3f77163e0242@mail.gmail.com> <20090426085401.3788fc9c@hyperion.delvare> <20090426124443.GA12455@auslistsprd01.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090426124443.GA12455@auslistsprd01.us.dell.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 07:44:43AM -0500, Matt Domsch wrote:
> On Sun, Apr 26, 2009 at 08:54:01AM +0200, Jean Delvare wrote:
> > Hi Kay,
> > 
> > Sorry, completely overlooked your reply... Ah, now I remember, I was
> > waiting for Michael to show up and comment on this. Michael, ping? As
> > long as we don't know the exact requirements and constraints of the
> > dell firmware tool, we're somewhat stuck.
> > 
> > Matt, maybe you can help? Could you please point us to the source code
> > of the dell firmware tool which relies on the dell_rbu driver?
> 
> 
> There's a git tree at:
>   http://linux.dell.com/git/?p=libsmbios.git
> 
> which you can get via rsync at:
>   rsync -va rsync://linux.dell.com/git/libsmbios.git/
> 
> the application is dellBiosUpdate, and the source is at this point in
> the tree:
> 
>   http://linux.dell.com/git/?p=libsmbios.git;a=blob;f=src/bin/dellBiosUpdate.cpp;h=b32e157b7ceb0be0d53eed4a4d171d24fe6456a7;hb=HEAD


I'll note there is a second implementation that uses dell_rbu, and
that is included in each and every "Dell Update Package" (aka DUP)
BIOS update posted on support.dell.com for every Dell PowerEdge server
for the past several years.  Because the updater and they BIOS payload
are packaged in the same package, a change which would require
changing that updater will result in requiring Dell to spin and
re-release hundreds of DUPs, which would not go over well...  Thank
you for being careful not to change the interface capriciously - it
could have a huge impact on us.

Thanks,
Matt


-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux

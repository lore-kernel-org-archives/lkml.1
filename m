Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbZD0Pa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbZD0Pa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbZD0PaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:30:16 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:28170 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbZD0PaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:30:14 -0400
Date: Mon, 27 Apr 2009 17:30:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Michael E Brown <Michael_E_Brown@dell.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Class device namespaces
Message-ID: <20090427173005.3ff1100b@hyperion.delvare>
In-Reply-To: <20090426130122.GB12455@auslistsprd01.us.dell.com>
References: <20090329174836.6de797d6@hyperion.delvare>
	<ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com>
	<20090330104952.26f03c13@hyperion.delvare>
	<ac3eb2510903300424s2604d027h653a3f77163e0242@mail.gmail.com>
	<20090426085401.3788fc9c@hyperion.delvare>
	<20090426124443.GA12455@auslistsprd01.us.dell.com>
	<20090426130122.GB12455@auslistsprd01.us.dell.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Apr 2009 08:01:22 -0500, Matt Domsch wrote:
> On Sun, Apr 26, 2009 at 07:44:43AM -0500, Matt Domsch wrote:
> > On Sun, Apr 26, 2009 at 08:54:01AM +0200, Jean Delvare wrote:
> > > Matt, maybe you can help? Could you please point us to the source code
> > > of the dell firmware tool which relies on the dell_rbu driver?
> > 
> > There's a git tree at:
> >   http://linux.dell.com/git/?p=libsmbios.git
> > 
> > which you can get via rsync at:
> >   rsync -va rsync://linux.dell.com/git/libsmbios.git/
> > 
> > the application is dellBiosUpdate, and the source is at this point in
> > the tree:
> > 
> >   http://linux.dell.com/git/?p=libsmbios.git;a=blob;f=src/bin/dellBiosUpdate.cpp;h=b32e157b7ceb0be0d53eed4a4d171d24fe6456a7;hb=HEAD

OK, thanks for the pointers.

> I'll note there is a second implementation that uses dell_rbu, and
> that is included in each and every "Dell Update Package" (aka DUP)
> BIOS update posted on support.dell.com for every Dell PowerEdge server
> for the past several years.  Because the updater and they BIOS payload
> are packaged in the same package, a change which would require
> changing that updater will result in requiring Dell to spin and
> re-release hundreds of DUPs, which would not go over well...  Thank
> you for being careful not to change the interface capriciously - it
> could have a huge impact on us.

I'll be careful, but you have to admit that duplicating utility code
like this is poor engineering from Dell :( I don't want to think of the
mess it will be if you ever have to fix a critical bug in that code.

-- 
Jean Delvare

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbZFWPRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbZFWPRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759070AbZFWPRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:17:08 -0400
Received: from torrent.cc.mcgill.ca ([132.206.27.49]:33961 "EHLO
	torrent.cc.mcgill.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963AbZFWPRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:17:07 -0400
Subject: Re: Panic booting 2.6.30
From: David Ronis <ronis@ronispc.chem.mcgill.ca>
Reply-To: ronis@ronispc.chem.mcgill.ca
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4A3C68E2.7000508@gmail.com>
References: <1245439404.25076.7.camel@ronispc.chem.mcgill.ca>
	 <4A3C68E2.7000508@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Department of Chemistry, McGill University
Date: Tue, 23 Jun 2009 11:17:04 -0400
Message-Id: <1245770225.11323.4.camel@ronispc.chem.mcgill.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.3 
X-PMX-Version: 5.4.2.338381, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2009.6.19.114543
X-McGill-WhereFrom: Internal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

That was it.  Including the appropriate driver in the kernel build
worked like a charm.

Thanks for your help--Short and correct!

David

On Fri, 2009-06-19 at 22:43 -0600, Robert Hancock wrote:
> On 06/19/2009 01:23 PM, David Ronis wrote:
> > I've just upgraded an older machine (a P3 running slackware 11.0) from
> > 2.6.26.5 to 2.6.30; the build was uneventful.  However, on reboot (using
> > lilo) I get:
> >
> > VSF:  Cannot open root device "hda2" or unknown-block(0,0)
> > Please append a correct root= boot option; here are the available
> > partions:<====== nothing shows here...
> > Kernel-Panic - not syncing.
> >
> > I had rebooted with and without root=hda2.   The old kernel is still
> > usable.
> 
> Make sure you configured in the proper IDE driver for your chipset. 
> Previously I believe the IDE driver would attach to unknown chipsets in 
> a crappy generic fashion, but I don't think it does anymore.
> 
> If that doesn't help, please post your kernel config and lspci output.
> 

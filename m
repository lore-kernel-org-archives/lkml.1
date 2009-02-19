Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbZBSXx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbZBSXx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 18:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbZBSXxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 18:53:44 -0500
Received: from outbound-mail-127.bluehost.com ([67.222.38.27]:50862 "HELO
	outbound-mail-127.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753960AbZBSXxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 18:53:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=W/fH5RNuzGEFMAeNGYYpj1PEEd2qEtq4nWQpRgV4Sa+U0SWBQCBWgMGs1dCxflbpv5oWLVyyAw8Bj8Ge6pjGiiXXAtFaw80uOq5aLHRZQfCXVKvon0Dib3FubJifDEeL;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] pcie_portdriver: FIX: pcie_port_device_remove
Date: Thu, 19 Feb 2009 15:53:40 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <m1ocx5ve8o.fsf@fess.ebiederm.org> <200902192247.46370.rjw@sisk.pl> <m13aeaxaw0.fsf@fess.ebiederm.org>
In-Reply-To: <m13aeaxaw0.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902191553.40408.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009 15:30:39 Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> > On Thursday 19 February 2009, Eric W. Biederman wrote:
> >> Andrew Morton <akpm@linux-foundation.org> writes:
> >> > There are large-scale and conflicting changes to this file in
> >> > linux-next.
> >> >
> >> > If we want to jam this fix into 2.6.29 (and it looks like something we
> >> > want) then this will trash the linux-next changes.  It will cause me
> >> > grief, and will cause Stephen grief unless the pci tree is suitably
> >> > changed, which will cause Jesse grief. Either way: grief.
> >>
> >> Ugh.
> >>
> >> I had better have a good hard look at linux-next.  I tried to ask
> >> earlier
> >
> > about
> >
> >> ongoing working but I didn't hear anything.
> >
> > Yes, you did: http://marc.info/?l=linux-kernel&m=123342565225134&w=4
>
> My apologies.  I should have said I did not recognize anything that
> was likely to conflict from what I hear from what I heard.  I did
> hear that the pcie port driver was touched to properly handle msi-x and I
> foolishly thought that was already merged upstream.  Especially after
> I glanced at Jesse's tree and I did not see any recent pci patches.
> Which led me to foolishly assume everything had already been merged
> into Linus's tree.
>
> Andrew with respect to 2.6.29 my patch while correct and useful has
> no immediate utility, as the pciehp driver will crash and burn horribly
> if you attempt to hotplug it.  So I should find the other pci port driver
> changes and rebase on top of them.  Assuming that patch is scheduled to
> merge for 2.6.30.

Yeah, if it's in my -next tree, it's scheduled for .30.  I have one other 
hotplug related set from Kenji-san for .29 as well (to fix a regression James 
reported).  Search for "fix wrong assumption" to check that one out.

-- 
Jesse Barnes, Intel Open Source Technology Center

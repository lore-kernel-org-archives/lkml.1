Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbYKQMDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbYKQMDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 07:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbYKQMDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 07:03:25 -0500
Received: from outbound-mail-106.bluehost.com ([69.89.22.6]:58780 "HELO
	outbound-mail-106.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753810AbYKQMDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 07:03:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=uniscape.net;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=b4OqD03UiN29yKh+T/3joXWYzbYkAvIILRRu0u6lRHiEXhHI6UgyOogqyKj6Do9n1Oawu9Y0j5RSWz0Z2VtoCmPI2hdMYQMjIXzysgoCxPCj+yBoJyN3LZKH8eq0LPM5;
Message-ID: <49215D33.4010607@uniscape.net>
Date: Mon, 17 Nov 2008 20:01:55 +0800
From: Yu Zhao <yu.zhao@uniscape.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Zhao, Yu" <yu.zhao@intel.com>, Greg KH <greg@kroah.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Leonid.Grossman@neterion.com" <Leonid.Grossman@neterion.com>,
       Matthew Wilcox <matthew@wil.cx>, H L <swdevyid@yahoo.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
References: <20081106154351.GA30459@kroah.com> <20081107061700.GD3860@kroah.com> <4913F2AA.90405@intel.com> <200811111048.45242.rusty@rustcorp.com.au>
In-Reply-To: <200811111048.45242.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {2990:host272.hostmonster.com:uniscape:uniscape.net} {sentby:smtp auth 58.41.76.172 authed with yu.zhao@uniscape.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Friday 07 November 2008 18:17:54 Zhao, Yu wrote:
> > Greg KH wrote:
> > > On Thu, Nov 06, 2008 at 04:40:21PM -0600, Anthony Liguori wrote:
> > >> Greg KH wrote:
> > >>> On Thu, Nov 06, 2008 at 10:47:41AM -0700, Matthew Wilcox wrote:
> > >>>> I don't think we really know what the One True Usage model is for VF
> > >>>> devices. Chris Wright has some ideas, I have some ideas and Yu Zhao
> > >>>> has some ideas. I bet there's other people who have other ideas too.
> > >>>
> > >>> I'd love to hear those ideas.
> > >>
> > >> We've been talking about avoiding hardware passthrough entirely and
> > >> just backing a virtio-net backend driver by a dedicated VF in the
> > >> host. That avoids a huge amount of guest-facing complexity, let's
> > >> migration Just Work, and should give the same level of performance.
> >
> > This can be commonly used not only with VF -- devices that have multiple
> > DMA queues (e.g., Intel VMDq, Neterion Xframe) and even traditional
> > devices can also take the advantage of this.
> >
> > CC Rusty Russel in case he has more comments.
> 
> Yes, even dumb devices could use this mechanism if you wanted to bind an 
> entire device solely to one guest.
> 
> We don't have network infrastructure for this today, but my thought was 
> to do something in dev_alloc_skb and dev_kfree_skb et al.

Is there any discussion about this on the netdev? Any prototype
available? If not, I'd like to create one and evaluate the performance
of virtio-net solution again the hardware passthrough.

Thanks,
Yu

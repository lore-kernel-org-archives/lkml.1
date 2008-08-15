Return-Path: <linux-kernel-owner+w=401wt.eu-S1760479AbYHORkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760479AbYHORkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 13:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbYHORkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 13:40:11 -0400
Received: from mail12.ca.com ([141.202.248.38]:20869 "EHLO mail12.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbYHORkK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 13:40:10 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] TALPA - a threat model?  well sorta.
Date: Fri, 15 Aug 2008 13:40:09 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4C12@USILMS12.ca.com>
In-Reply-To: <alpine.DEB.1.10.0808151032121.15109@asgard.lang.hm>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] TALPA - a threat model?  well sorta.
Thread-Index: Acj+/OSHPeHpqulKRsyriu2rE93OJwAACD9w
References: <1218645375.3540.71.camel@localhost.localdomain><20080813103951.1e3e5827@infradead.org><1218653864.3540.109.camel@localhost.localdomain><20080813143908.38796217@infradead.org><1218723133.3540.137.camel@localhost.localdomain><48A55574.9070508@aitel.hist.no> <1218796645.10800.242.camel@twins> <2629CC4E1D22A64593B02C43E855530304AE4BF6@USILMS12.ca.com> <alpine.DEB.1.10.0808150924260.15109@asgard.lang.hm> <2629CC4E1D22A64593B02C43E855530304AE4C0C@USILMS12.ca.com> <alpine.DEB.1.10.0808151032121.15109@asgard.lang.hm>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: <david@lang.hm>
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Helge Hafting" <helge.hafting@aitel.hist.no>,
       <linux-kernel@vger.kernel.org>, <malware-list@lists.printk.net>,
       <hch@infradead.org>, <andi@firstfloor.org>, <viro@ZenIV.linux.org.uk>,
       <alan@lxorguk.ukuu.org.uk>, "Arjan van de Ven" <arjan@infradead.org>
X-OriginalArrivalTime: 15 Aug 2008 17:40:09.0556 (UTC) FILETIME=[F67BF940:01C8FEFD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: david@lang.hm [mailto:david@lang.hm]
> Sent: Friday, August 15, 2008 1:33 PM
> To: Press, Jonathan
> Cc: Peter Zijlstra; Helge Hafting; linux-kernel@vger.kernel.org;
malware-
> list@lists.printk.net; hch@infradead.org; andi@firstfloor.org;
> viro@ZenIV.linux.org.uk; alan@lxorguk.ukuu.org.uk; Arjan van de Ven
> Subject: RE: [malware-list] TALPA - a threat model? well sorta.
> 
> On Fri, 15 Aug 2008, Press, Jonathan wrote:
> 
> >> -----Original Message-----
> >> From: david@lang.hm [mailto:david@lang.hm]
> >>> The problem is that you have to account for the cases where the
malware
> >>> made it onto the system even if you were trying to catch it ahead
of
> >>> time.  For example:
> >>>
> >>> - Administrator turns off or reduces AV protection for some reason
for
> >>> some period of time.  It happens all the time.
> >>
> >> according to the threat model actions of the administrator do not
matter.
> >
> > Sorry, I don't know what you mean.
> 
> the threat model that was posted two days ago in the initial message
of
> this thread specificly stated that actions of root are not something
that
> this is trying to defend against.

I think you may have missed the point of any such statement.

Just to clarify...

The model does not exclude root-owned processes from the notification
and scanning sequence.  If root attempts to execute a file, that file
would be scanned before the execution is allowed.  If a root-owned
process attempts to open a file, that access would be blocked until the
file is scanned.  If a root-owned process closes a file that has been
written to, that file would be scanned.

In addition, to generalize from the incorrect idea that the actions of
root are not being defended against to the idea that the possible
impacts of an administrator's actions in configuring an application
should not be accounted for at all in our thinking doesn't make sense to
me anyway.


Jon Press




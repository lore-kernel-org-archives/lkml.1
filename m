Return-Path: <linux-kernel-owner+w=401wt.eu-S1031302AbXDQXRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031302AbXDQXRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 19:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031297AbXDQXRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 19:17:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031294AbXDQXRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 19:17:01 -0400
Subject: Re: AppArmor FAQ
From: Karl MacMillan <kmacmill@redhat.com>
To: Crispin Cowan <crispin@novell.com>
Cc: James Morris <jmorris@namei.org>, John Johansen <jjohansen@suse.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <4625505C.6010802@novell.com>
References: <20070416213350.GB4030@suse.de>
	 <Line.LNX.4.64.0704161846110.13905@d.namei>
	 <1176846917.5946.79.camel@localhost.localdomain>
	 <4625505C.6010802@novell.com>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 19:13:26 -0400
Message-Id: <1176851606.5946.120.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 15:55 -0700, Crispin Cowan wrote:
> Karl MacMillan wrote:
> > On Mon, 2007-04-16 at 20:20 -0400, James Morris wrote:
> >   
> >> On Mon, 16 Apr 2007, John Johansen wrote:
> >>     
> >>> Label-based security (exemplified by SELinux, and its predecessors in
> >>> MLS systems) attaches security policy to the data. As the data flows
> >>> through the system, the label sticks to the data, and so security
> >>> policy with respect to this data stays intact. This is a good approach
> >>> for ensuring secrecy, the kind of problem that intelligence agencies have.
> >>>       
> >> Labels are also a good approach for ensuring integrity, which is one of 
> >> the most fundamental aspects of the security model implemented by SELinux.  
> >>
> >> Some may infer otherwise from your document.
> >>     
> > Not only that, the implication that secrecy is only useful to
> > intelligence agencies is pretty funny.
> That was not the claim.

It might not have been the claim, but I certainly think it was the
implication.

>  Rather, that intelligence agencies have a very
> strong need for privacy, and will go to greater lengths to get it,
> including using MLS systems. I contend that while most organizations
> want privacy, they don't want it so badly that they will put up with
> MLS, and so are looking for a more tolerable form of security.
> 

Definitely - which is why SELinux is primarily about type enforcement.

> This is relevant here because information flow is the main advantage of
> labels over pathnames for access control.

I would say that controlling information flow is _one_ of the main
advantages of labels. There are others.

>  AppArmor does not attempt to
> manage information flow, allowing it to use pathnames to achieve ease of
> use. If you want information flow control, then by all means use a
> label-based system.
> 

You're trying to force a false choice between "ease of use" and
"information flow control". These AppArmor / SELinux debates are
irritating enough without these kinds of misleading rhetorical
techniques.

Karl



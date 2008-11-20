Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbYKTCqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbYKTCqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 21:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYKTCqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 21:46:40 -0500
Received: from ik-out-1112.google.com ([66.249.90.179]:64891 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYKTCqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 21:46:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J4mKTuFvnA/ZQHoTj2yYRJQf8BCeN/cU9Hef0+0tkvzKxsWKr7fhqFm6XN4ebs7ZU3
         2wxfQTLfIQnpHZk0tVZINc0999ENwCNW1H5h7nXdrwpmgS9cGis+5AgvkdrvsHhtc89O
         T89OuDL5u68UhQwZ8C1+HWoZR3dkztspmmHsc=
Date: Thu, 20 Nov 2008 05:50:19 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Pavel Emelyanov <xemul@openvz.org>, David Miller <davem@davemloft.net>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Patrick McHardy <kaber@trash.net>, den@openvz.org,
       Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: Current state of Network Namespaces (NETNS, CLONE_NEWNET)?
Message-ID: <20081120025019.GA2220@x200.localdomain>
References: <492489D1.5080502@gmail.com> <m1d4grfa8w.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d4grfa8w.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 05:37:35PM -0800, Eric W. Biederman wrote:
> Michael Kerrisk <mtk.manpages@googlemail.com> writes:
> 
> > Sorry for the shotgun mail, but in the end,  it's
> > not clear who can best answer my question(s).
> >
> > I'm currently trying to add documentation of all of
> > the undocumented CLONE_* flags.  One of these is
> > CLONE_NEWNET, and I could use (quite a lot of) help.  
> >
> > My questions:
> >
> > What is the current state of the network namespace 
> > implementation?  Is it complete?  
> 
> No.  It is fairly close though and there is general agreement
> on what it is.
> 
> ipv4 and ipv6 are mostly complete and useable.
> ip tables support is in progress.

iptables will be mostly complete in 2.6.28.

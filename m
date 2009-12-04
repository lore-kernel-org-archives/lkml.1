Return-Path: <linux-kernel-owner+w=401wt.eu-S932583AbZLDXsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbZLDXsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 18:48:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932472AbZLDXsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 18:48:04 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36295 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbZLDXsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 18:48:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L5nt+yf58SkH+eFVx6l0DkjdAockBvamzt/kki1TmXkIYvUFtAC0NtpcpytaFSEOun
         boelveRVscFz2XFi5jp9iHvDSoDHtMuek1kYvox9w4pv2JY7vDPRAVl0gtwbPMeTSFWN
         CIC1CdABS/E80ppAO5JstWjGiAaCqFB1cvueY=
Date: Sat, 5 Dec 2009 00:47:57 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Caleb Cushing <xenoterracide@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       e1000-devel@lists.sourceforge.net
Subject: Re: large packet loss take2 2.6.31.x
Message-ID: <20091204234756.GA3517@ami.dom.local>
References: <20091125191105.GA3167@ami.dom.local>
 <81bfc67a0911271007o1fb8f8c2vdd36e8585280e4da@mail.gmail.com>
 <20091127213640.GA2611@ami.dom.local>
 <81bfc67a0911271435g4106652bpe8c9ea07893d0ebd@mail.gmail.com>
 <20091127224206.GA3350@ami.dom.local>
 <81bfc67a0912031749y15faed66s9c8a924684c97a19@mail.gmail.com>
 <20091204090524.GB6478@ff.dom.local>
 <81bfc67a0912041028w16668d0cx4da04bee989eef4a@mail.gmail.com>
 <20091204204443.GA2736@ami.dom.local>
 <81bfc67a0912041507k6ef497f9w7b9294c90012e1a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81bfc67a0912041507k6ef497f9w7b9294c90012e1a1@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 06:07:42PM -0500, Caleb Cushing wrote:
> > So, again, if you're willing to debug this, the new bugzilla report
> > seems reasonable to me, plus maybe some notice to this #11998 too.
> 
> I will later today. I'm thinking since I now have 2 active nics...
> would hooking the 1 card directly to the other and then running the
> tests be helpful? (I wish this mobo had a 3rd pci slot because I'd
> have put a 3rd card in so I can connect to the net at the same time.

I guess, you should better wait with new tests for some assistance
from e1000e maintainers - it seems they might be interested in some
specific dumps and registers - like in this #11998 case.

Jarek P.

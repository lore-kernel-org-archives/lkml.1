Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbYHOUFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbYHOUFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbYHOUFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:05:46 -0400
Received: from mail.lang.hm ([64.81.33.126]:34390 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbYHOUFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:05:46 -0400
Date: Fri, 15 Aug 2008 13:05:47 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Valdis.Kletnieks@vt.edu
cc: "Press, Jonathan" <Jonathan.Press@ca.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       hch@infradead.org, andi@firstfloor.org, viro@ZenIV.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] TALPA - a threat model? well sorta.
In-Reply-To: <22811.1218823607@turing-police.cc.vt.edu>
Message-ID: <alpine.DEB.1.10.0808151257440.15109@asgard.lang.hm>
References: <1218645375.3540.71.camel@localhost.localdomain> <20080813103951.1e3e5827@infradead.org> <1218653864.3540.109.camel@localhost.localdomain> <20080813143908.38796217@infradead.org> <1218723133.3540.137.camel@localhost.localdomain>
 <48A55574.9070508@aitel.hist.no> <1218796645.10800.242.camel@twins> <2629CC4E1D22A64593B02C43E855530304AE4BF6@USILMS12.ca.com> <alpine.DEB.1.10.0808150924260.15109@asgard.lang.hm> <2629CC4E1D22A64593B02C43E855530304AE4C0C@USILMS12.ca.com>
 <alpine.DEB.1.10.0808151032121.15109@asgard.lang.hm> <2629CC4E1D22A64593B02C43E855530304AE4C12@USILMS12.ca.com>            <alpine.DEB.1.10.0808151042500.15109@asgard.lang.hm> <22811.1218823607@turing-police.cc.vt.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008, Valdis.Kletnieks@vt.edu wrote:

> On Fri, 15 Aug 2008 10:47:15 PDT, david@lang.hm said:
>
>> in any case the vunerability is limited as the next time the signatures
>> are updated the files would get scanned again, so I don't think it's a big
>> problem in practice.
>
> This problem is actually identical to "new file scanned, but you don't have
> the signature available yet so malware isn't detected".
>
> Those of us who have seen large mail servers pile up queues in the 10s of
> millions in the 45 minutes between when the worm went critical-mass and when
> we got a signature might disagree on it not being a big problem in practice.
>
> Of course, if that's considered "outside" the threat model, somebody better
> start writing down exactly what small corner of threat model this is actually
> helping against...

go back to the beginning of this thread. that is defining the (very 
limited) thread model that they are trying to defend against.

the rest of us are not trying to defend against this threat model. we are 
trying to identify the appropriate infrastructure that could be used by 
the TALPA folks for their work, that can also be reasonable for inclusion 
in the kernel (which includes being suitable for other similar purposes, 
such as filesystem indexing)

we agree that the threat they are trying to defend against is a very small 
portion of the overall threat, but there are other components (including 
SELinux) that are available to deal with other portions of the overall 
threat.

if you want to say that the solution is too limited to be worth while, 
then you need to write a new threat model that you think is what should be 
defended against and then we can start discussing how to defend against 
it.

David Lang

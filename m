Return-Path: <linux-kernel-owner+w=401wt.eu-S1760940AbYHOUIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbYHOUIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbYHOUIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:08:21 -0400
Received: from mail.lang.hm ([64.81.33.126]:44965 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbYHOUIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:08:21 -0400
Date: Fri, 15 Aug 2008 13:08:43 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Press, Jonathan" <Jonathan.Press@ca.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       hch@infradead.org, andi@firstfloor.org, viro@ZenIV.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@infradead.org>
Subject: RE: [malware-list] TALPA - a threat model?  well sorta.
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4C15@USILMS12.ca.com>
Message-ID: <alpine.DEB.1.10.0808151305540.15109@asgard.lang.hm>
References: <1218645375.3540.71.camel@localhost.localdomain><20080813103951.1e3e5827@infradead.org><1218653864.3540.109.camel@localhost.localdomain><20080813143908.38796217@infradead.org><1218723133.3540.137.camel@localhost.localdomain><48A55574.9070508@aitel.hist.no>
 <1218796645.10800.242.camel@twins> <2629CC4E1D22A64593B02C43E855530304AE4BF6@USILMS12.ca.com> <alpine.DEB.1.10.0808150924260.15109@asgard.lang.hm> <2629CC4E1D22A64593B02C43E855530304AE4C0C@USILMS12.ca.com> <alpine.DEB.1.10.0808151032121.15109@asgard.lang.hm>
 <2629CC4E1D22A64593B02C43E855530304AE4C12@USILMS12.ca.com> <alpine.DEB.1.10.0808151042500.15109@asgard.lang.hm> <2629CC4E1D22A64593B02C43E855530304AE4C15@USILMS12.ca.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008, Press, Jonathan wrote:

>> -----Original Message-----
>> From: david@lang.hm [mailto:david@lang.hm]
>> Sent: Friday, August 15, 2008 1:47 PM
>> To: Press, Jonathan
>> Cc: Peter Zijlstra; Helge Hafting; linux-kernel@vger.kernel.org;
> malware-
>> list@lists.printk.net; hch@infradead.org; andi@firstfloor.org;
>> viro@ZenIV.linux.org.uk; alan@lxorguk.ukuu.org.uk; Arjan van de Ven
>> Subject: RE: [malware-list] TALPA - a threat model? well sorta.
>>
>> On Fri, 15 Aug 2008, Press, Jonathan wrote:
>>> In addition, to generalize from the incorrect idea that the actions
> of
>>> root are not being defended against to the idea that the possible
>>> impacts of an administrator's actions in configuring an application
>>> should not be accounted for at all in our thinking doesn't make
> sense to
>>> me anyway.
>>
>> questions had been raised about how this model could defend against
> all
>> the tricky things that root can do, the answer was that they are not
>> trying to defend against root doing tricky things.
>>
>> turning off the scanner, letting things get infected, and turning it
> back
>> on would fall in the same catagory as marking a file that the scanner
>> marked as bad as sucessfully scanned.
>
> Well, I agree that there are things you can't prevent, that's for sure.
> But the point is to build the "threat model" and application
> functionality around the idea that IF they happen, you want to be able
> to plug the resulting holes as well as you can.  You can't simply close
> your eyes to the possibility.

correct, and the threat model that was documented as what we are trying to 
defend against explicity says that actions by root (or other running 
programs, including running malware) are not part of the threat model they 
are trying to address (it doesn't mean that they aren't important, just 
that they are not trying to deal with them). All they are trying to do is 
to have a way to scan files. Since there is use in having support for this 
(for security theater, a little real security, and for other purposes like 
indexing) we are figuing out how to provide tools that would allow this.

David Lang

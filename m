Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbZC3KuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbZC3KuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 06:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZC3KuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 06:50:09 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:32095 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZC3KuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 06:50:05 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNXfZkKf55cV
X-RZG-CLASS-ID: mo05
Message-ID: <49D0A3D6.4000300@ursus.ath.cx>
Date: Mon, 30 Mar 2009 12:49:58 +0200
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Theodore Tso <tytso@mit.edu>, Mark Lord <lkml@rtr.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>	<alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>	<49CD7B10.7010601@garzik.org>	<49CD891A.7030103@rtr.ca>	<49CD9047.4060500@garzik.org>	<49CE2633.2000903@s5r6.in-berlin.de>	<49CE3186.8090903@garzik.org>	<49CE35AE.1080702@s5r6.in-berlin.de>	<49CE3F74.6090103@rtr.ca>	<20090329231451.GR26138@disturbed>	<20090330003948.GA13356@mit.edu>	<49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu>
In-Reply-To: <20090330100546.51907bd2@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 30.03.2009 11:05 Alan Cox wrote:
>> It seems you still didn't get the point. ext3 data=ordered is not the
>> problem. The problem is that the average developer doesn't expect the fs
>> to _re-order_ stuff. This is how most common fs did work long before
>>     
>
> No it isn´t. Standard Unix file systems made no such guarantee and would
> write out data out of order. The disk scheduler would then further
> re-order things.
>
>   
You surely know that better: Did fs actually write "later" data quite
long before "earlier" data? During the flush data may be re-ordered, but
was it also _done_ outside of it?

> If you think the ¨guarantees¨ from before ext3 are normal defaults you´ve
> been writing junk code
>
>   
I'm still on ReiserFS since it was considered stable in some SuSE 7.x.
And I expected it to be fairly ordered, but as a network protocol
programmer I didn't rely on the ordering of fs write-outs yet.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760495AbYF3ShV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760495AbYF3ShV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYF3ShG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:37:06 -0400
Received: from gw.goop.org ([64.81.55.164]:49662 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbYF3ShF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:37:05 -0400
Message-ID: <486927AB.1060006@goop.org>
Date: Mon, 30 Jun 2008 11:36:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
 64-bit Xen support
References: <20080626105722.GA12640@elte.hu> <20080626105818.GA13805@elte.hu> <4863A8E6.1010807@goop.org> <20080627160333.GA27072@elte.hu> <486539A3.3030102@goop.org> <20080629084318.GA28815@elte.hu> <48684CD4.7040403@goop.org> <20080630082135.GA22844@elte.hu> <20080630092209.GA29815@elte.hu> <48691524.5010806@goop.org> <20080630181221.GF23739@elte.hu>
In-Reply-To: <20080630181221.GF23739@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>>> config and full log can be found at:
>>>
>>>  http://redhat.com/~mingo/misc/config-Mon_Jun_30_11_11_51_CEST_2008.bad
>>>   
>>>       
>> That config doesn't build for me.  When I put it in place and do "make 
>> oldconfig" it still asks for lots of config options (which I just set 
>> to default).  But when I build it fails with:
>>     
>
> try 'make ARCH=i386 oldconfig' - does it work better that way?
>   

Er, we're talking about 64-bit here, aren't we?  The log messages are 
from a 64-bit kernel.

Well, it was the wrong config anyway, which I guess is the source of 
this confusion.

(I thought ARCH= to select 32/64 was going away now that the config has 
the bitsize config?)

    J

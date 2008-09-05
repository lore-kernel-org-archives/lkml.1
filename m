Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbYIESda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbYIESda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYIESdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:33:22 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:49959 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYIESdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:33:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=W7IqISSvtrfEldSOQaa0p6jJAuLWN1mK7L3qlQTznQ4tB1D4OgPO9aKcB7qGQWlQ7C
         eH4SpVarBDOYrUFeJ9eXKzGkW7i34R4lehHM4/pSzDwkxw2rBtGf8iLzLtjbdAW3eTYM
         cQlnvOYEbOoT3Ixi0e9ypFqP2qgRbr78lJnaM=
Message-ID: <d120d5000809051133h1a51d68bs56db0397a321bc9f@mail.gmail.com>
Date: Fri, 5 Sep 2008 14:33:18 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [PATCH] ucb1400_ts depends SND_AC97_BUS
Cc: "Nicolas Pitre" <nico@cam.org>, "Randy Dunlap" <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>,
       linux-next@vger.kernel.org
In-Reply-To: <s5hprniv7ep.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20061209003635.e778ff76.randy.dunlap@oracle.com>
	 <20080904195744.f367cd2d.randy.dunlap@oracle.com>
	 <alpine.LFD.1.10.0809050028590.23787@xanadu.home>
	 <20080904214444.0dccf859.randy.dunlap@oracle.com>
	 <alpine.LFD.1.10.0809050104560.23787@xanadu.home>
	 <s5htzcvt7id.wl%tiwai@suse.de>
	 <alpine.LFD.1.10.0809051049460.23787@xanadu.home>
	 <s5hhc8u8soi.wl%tiwai@suse.de>
	 <alpine.LFD.1.10.0809051231120.23787@xanadu.home>
	 <s5hprniv7ep.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2008 at 1:17 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Fri, 05 Sep 2008 12:32:32 -0400 (EDT),
> Nicolas Pitre wrote:
>>
>> On Fri, 5 Sep 2008, Takashi Iwai wrote:
>>
>> > At Fri, 05 Sep 2008 10:52:25 -0400 (EDT),
>> > Nicolas Pitre wrote:
>> > >
>> > > On Fri, 5 Sep 2008, Takashi Iwai wrote:
>> > >
>> > > > > This was fixed 2 years ago.  Who broke it this time?
>> > > >
>> > > > Oh, it must be me.
>> > >
>> > > I think both your patch and the one I previously posted are needed.
>> >
>> > Could you repost?  I can't find it easily now.
>
> Thanks.  For linux-next, yes, it's needed.  But it's not for 2.6.27.
>
> Meanwhile, my fix should be included in 2.6.27 since it's a
> regression.
>
> Randy, could you check whether these two patches fix your problem?
> I'll put my patch to my tree for the next pull request after your
> confirmation.
>
> Can Nicolas's patch be to input tree, or any other taker?
>

I'll take it.

-- 
Dmitry

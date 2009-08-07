Return-Path: <linux-kernel-owner+w=401wt.eu-S933615AbZHGUJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615AbZHGUJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933581AbZHGUJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:09:45 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:8170 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562AbZHGUJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:09:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=lqHplIeii/waGZ00Bl/shLL4xLBGTVK9woi+P+Rj3UXGywV0+GLOoRakRl8wlyp3Xs
         3RtJrevQAOuVGZiJx8TsbfAKbnUqOr2dw08/mqKJB1Op2OaRjjQ+xYDxYacC+aXuNFBG
         NwrPH8Ar2iFrzw2c3KRO/BmTcpe1LEZVzUt+o=
Message-ID: <4A7C8A04.3060005@googlemail.com>
Date: Fri, 07 Aug 2009 21:09:40 +0100
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Reply-To: alan-jenkins@tuffmail.co.uk
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: David VomLehn <dvomlehn@cisco.com>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-usb@vger.kernel.org, greg@kroah.com,
       linux-scsi@vger.kernel.org, netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 2/7 v3] initdev:kernel:USB init device discovery notification
References: <9b2b86520908070832p2d1658b0t8b1d89d1a034bb9a@mail.gmail.com> <Pine.LNX.4.44L0.0908071142260.3063-100000@iolanthe.rowland.org> <9b2b86520908071017h606e595fr4488d6ff61cb337c@mail.gmail.com> <20090807174209.GB30450@cuplxvomd02.corp.sa.net>
In-Reply-To: <20090807174209.GB30450@cuplxvomd02.corp.sa.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David VomLehn wrote:
> On Fri, Aug 07, 2009 at 06:17:51PM +0100, Alan Jenkins wrote:
>   
>> On 8/7/09, Alan Stern <stern@rowland.harvard.edu> wrote:
>>     
>>> On Fri, 7 Aug 2009, Alan Jenkins wrote:
>>>
>>>       
>>>>> +/* The mask of possible USB boot devices depends on what drivers and
>>>>> + * options have been configured into the kernel.  There are too many
>>>>> + * USB network config options to list here, so just assume it is always
>>>>> + * possible to have a USB network device.
>>>>> + */
>>>>>           
>>>> That could be fixed though.  Make the "USB Network Adaptors" menu into
>>>> an option.

> I remember thinking about this and seem to recall that Alan Stern and I
> tossed this idea around, but didn't act on it. Such a thing holds potential
> for avoiding an unnecessary delay during boot. Whether it actually makes
> things faster in a given configuration will depend on that configuration's
> critical path, but I would welcome such a patch on the basis that it's
> unlikely to hurt and could improve boot times in some circumstances.
>   

Bother, I see why this doesn't work now.  There are all the USB
*wireless* network drivers outside the menu.

Thanks anyway
Alan

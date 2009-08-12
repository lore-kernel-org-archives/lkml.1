Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbZHLMTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbZHLMTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 08:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbZHLMTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 08:19:51 -0400
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:46123 "EHLO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZHLMTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 08:19:51 -0400
Message-ID: <4A82B360.8000905@gefanuc.com>
Date: Wed, 12 Aug 2009 13:19:44 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 2/5] Staging: vme: add VME userspace driver
References: <20090810152606.GA23319@braap.org> <4A804B0B.5020809@gefanuc.com> <20090810203637.GD3055@braap.org> <4A8133ED.6070304@gefanuc.com> <20090811094025.GC3251@braap.org> <4A81683D.2030408@gefanuc.com> <20090811210146.GB9910@braap.org> <4A827A84.3060906@gefanuc.com> <20090812093949.GB2604@braap.org> <4A8291F5.8060406@gefanuc.com> <20090812112020.GB10800@braap.org>
In-Reply-To: <20090812112020.GB10800@braap.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emilio G. Cota wrote:
> Martyn Welch wrote:
>> However, I also need to consider other cases, such as communications  
>> between multiple SBCs and potentially a few slave devices. I have a need  
>> for this *now*, not in the future. To me, slave support and to a lesser  
>> degree location monitor support is important now, hence why it's  
>> supported in my driver and core. Hence why I am asking, how do you  
>> propose to support these features?
> 
> Point taken.
> 
> Could you tell me a bit more about your needs on this respect?
> So, you have multiple SBCs (some of them as masters, some others
> as slaves) running Linux and want to communicate between them?

Yes - though potentially each card will be both a master and a slave.

> Have you got working code for all that?

In so far as the VME core and tsi-148 driver supports the required functionality, I believe so. We have systems supporting this, though currently with different OSes. We also have a bit of legacy Linux VME code, using the old style of interface. At the moment my priority is less on individual applications and more focused towards ensuring we have a robust API which will support all the features we are likely to require for the chipsets that we have in our products.

We have briefly talked about a "Ethernet over VME" like the "Ethernet over RapidIO" driver, however, this currently isn't top priority.

Martyn

> 
> E.


-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)127322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189

Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbZHLKSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbZHLKSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbZHLKSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:18:35 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:47295 "EHLO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbZHLKSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:18:35 -0400
Message-ID: <4A829729.60208@gefanuc.com>
Date: Wed, 12 Aug 2009 11:19:21 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
References: <20090811144914.GB32658@braap.org> <4A8189D9.4080709@gefanuc.com> <20090811153633.GC32658@braap.org> <4A819130.5080802@gefanuc.com> <20090811154226.GD32658@braap.org> <4A819E80.90103@gefanuc.com> <20090811204835.GA9910@braap.org> <4A828395.9040006@gefanuc.com> <20090812095436.GC2604@braap.org> <4A829271.6000507@gefanuc.com> <20090812100927.GA10800@braap.org>
In-Reply-To: <20090812100927.GA10800@braap.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emilio G. Cota wrote:
> Martyn Welch wrote:
>   
>> Apart from : not mapping regions of the VME bus that you are not using.
>>     
>
> The tsi148 mappings have to be on 64k boundaries, so yes, it
> happens that sometimes you map a bit more than what you need.
> But there's no way to get around that; it's a hardware thing
> so we just accept it.
>
>   

I agree - however you're talking about mapping areas which we don't need 
to map, to save the use of a window.

Martyn
> E.
>   


-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189

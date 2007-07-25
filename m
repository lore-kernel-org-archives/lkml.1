Return-Path: <linux-kernel-owner+w=401wt.eu-S932485AbXGYV3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbXGYV3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbXGYV3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:29:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:34895 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbXGYV3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:29:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=mZMPpHsg+z3nBdRDsI2KXHDA2e6GsAbWBw8YxQ0XLbJcnUuex1l5v5AWPZDV9v0cKs0Bi2Ga+3jWGpOW8SfN0UOJmhnbwJ9AjjOD1BGo2nWlDMjQPvdu9ia32bIgGD/6H1U7OyAmiEL7PFeW5/J1+iBRIRNwvSOiX5G8ZqFMx58=
Message-ID: <46A7BFF6.2080006@googlemail.com>
Date: Wed, 25 Jul 2007 23:26:14 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, gregkh@suse.de
Subject: Re: 2.6.23-rc1-mm1
References: <20070725040304.111550f4.akpm@linux-foundation.org> <6bffcb0e0707251148m219d1c9fqb557d3e5364f679b@mail.gmail.com> <20070725185328.GA28199@uranus.ravnborg.org> <46A7A1EF.8060307@zytor.com> <46A7B983.90407@googlemail.com> <46A7BB12.7060504@googlemail.com> <46A7BC79.7020902@zytor.com> <46A7BCE3.3040709@googlemail.com> <46A7BE26.4010900@zytor.com>
In-Reply-To: <46A7BE26.4010900@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Gabriel C wrote:
>> H. Peter Anvin wrote:
>>> Gabriel C wrote:
>>>>> WARNING: Absolute relocations present
>>>>> Offset     Info     Type     Sym.Value Sym.Name
>>>>> c0202e73 00703601   R_386_32 c03071bc  _sdata
>>>>>
>>>>> $ grep c03071bc System.map
>>>>> c03071bc R __tracedata_end
>>>>> c03071bc A _sdata
>>> What is at 0xc0202e73?
>> grep returns nothing for 0xc0202e73
>>
> 
> What is the symbol immediately before and after that, then?

I just have an 0xc0202e0c here which is :

c0202e0c T kobject_init

You can get the System.map from there :

http://194.231.229.228/MM/System.map

> 
> 	-hpa
> 

Gabriel

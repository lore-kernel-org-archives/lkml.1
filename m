Return-Path: <linux-kernel-owner+w=401wt.eu-S1764887AbXGYVCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764887AbXGYVCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760887AbXGYVCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:02:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:6424 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbXGYVCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:02:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=MIMpRhpG7qcZAdjbigzWOVxeYktCSP9rK0MBG55jgnOvknGpZmisg7HztHRxrChqaqvW7akQa79UmH7YyKI6U2bpEtKED4VUzvOzmjNG+5n3RdWbXvkyyLssZBmmhw36VSrjfJ2zumrczycpgBbbyqrtb/Vl096i0V+TiTGqMEs=
Message-ID: <46A7B983.90407@googlemail.com>
Date: Wed, 25 Jul 2007 22:58:43 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc1-mm1
References: <20070725040304.111550f4.akpm@linux-foundation.org> <6bffcb0e0707251148m219d1c9fqb557d3e5364f679b@mail.gmail.com> <20070725185328.GA28199@uranus.ravnborg.org> <46A7A1EF.8060307@zytor.com>
In-Reply-To: <46A7A1EF.8060307@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Sam Ravnborg wrote:
>> On Wed, Jul 25, 2007 at 08:48:50PM +0200, Michal Piotrowski wrote:
>>> On 25/07/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/
>>>>
>>>>
>>> Andi, this might be interesting for you
>>>
>>> make allmodconfig
>>> make
>>> [...]
>>> WARNING: Absolute relocations present
>>> Offset     Info     Type     Sym.Value Sym.Name
>>> c02041b3 00705601   R_386_32 c0308aa8  _sdata
>> Who did spit out this warning. Can you please provide make V=1
>> where we see the lines preceeding the warning.
>>
>> And config please.
>>
> 
> config: "make allmodconfig"
> 
> System.map would be more interesting, especially what is at 0xc02041b3.

I get here :

WARNING: Absolute relocations present
Offset     Info     Type     Sym.Value Sym.Name
c0202e73 00703601   R_386_32 c03071bc  _sdata

$ grep c03071bc System.map
c03071bc R __tracedata_end
c03071bc A _sdata

> 
> 	-hpa


Gabriel

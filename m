Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183Ab0AMRMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0AMRMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 12:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174Ab0AMRMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 12:12:21 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:40662 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab0AMRMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:12:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=yCsQVXQlMabKW1Af22JIjuP7VssVDmHFB5iciCTLUtGDe/qUaw09vxC12EOJuxir6N
         rpWiTD+jhcP7gYirk06ogVXos/qFMDj1ZUBWZ+9YFaaifPV/DwhnYyhj/bhc/X4E40mS
         /sgwi5vEMwk7yb2BPlC3RhhzlL+24nqob7IXo=
Message-ID: <4B4DFF04.2070109@googlemail.com>
Date: Wed, 13 Jan 2010 18:12:36 +0100
From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Tilman Schmidt <tilman@imap.cc>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org
Subject: Re: [Question]  For what stand's __initdata, __devinit etc. ?
References: <4B4CAA49.4090707@googlemail.com> <20100112234228.GA21777@khazad-dum.debian.net> <4B4DB0E3.9020707@imap.cc> <4B4DF6B1.406@s5r6.in-berlin.de>
In-Reply-To: <4B4DF6B1.406@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/10 17:37, Stefan Richter wrote:
> Tilman Schmidt wrote:
>> Am 2010-01-13 00:42 schrieb Henrique de Moraes Holschuh:
>>> On Tue, 12 Jan 2010, René Bolldorf wrote:
>>>> Hi,
>>>> Do we really need this?
>>>> It will be nice if someone can me explain this.
>>>
>>> http://kernelnewbies.org/FAQ/InitExitMacros
>>
>> That's far from complete. It does not, for example, mention __devinit.
>
> This wiki contains also somewhat misleadingly worded text:  "But why
> must you use these macros ?"  This should read:  "But why would you want
> to use these macros?"
>
> Answer:  They are a micro-optimization which allows the kernel to free
> memory that was occupied by this code at some point, because that code
> won't be used after that point anymore.  (In case of exit macros:  These
> are hints to discard some code from a build in case of certain kernel
> configurations.)  These macros only affect code which is statically
> linked into the kernel.
>
> Some macros, like for example __devinit, have so obscure uses and
> marginal benefits that a normal developer should not bother about them.
> __devinit in particular does not have any effect at all --- except if
> CONFIG_HOTPLUG is not defined.  This may happen in configurations for
> embedded systems.  But the majority of device drivers that you can find
> in the kernel tree are irrelevant (i.e. configured off) on such systems
> anyway.
>
> Some more information on these macros can be found in Corbet, Rubini,
> Kroah-Hartman: Linux Device Drivers, 3rd edition a.k.a. LDD3, which is
> also gratis available on the Web.

Thanks @all :-)

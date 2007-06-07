Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbXFGHBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbXFGHBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFGHBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:01:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:14938 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbXFGHBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:01:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dSP2dT8VdTVKg5By6ViJl5Y/DVSAFDgm7mZoeBo72MQlg55gv7d78QahYttLglbiq9OF8QlF4eZbQsHt1Bg4iAVmRWZF2xn806sG75VIxTP2S7DqPMinlfMuc6228YQsP3l/jW4vgLH9tWdVmeYDz6b7XH0swsUU6ZDBVwZ+eLQ=
Message-ID: <4667AD3F.1010405@gmail.com>
Date: Thu, 07 Jun 2007 09:01:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
References: <200706061421.l56ELDfB004305@harpo.it.uu.se>	<4666D3F8.4010002@gmail.com> <20070606105650.bebf1c95.akpm@linux-foundation.org> <4666FBE8.3030103@gmail.com> <4667A93A.4060608@gmail.com>
In-Reply-To: <4667A93A.4060608@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo napsal(a):
> Jiri Slaby wrote:
>> Andrew Morton napsal(a):
>>> On Wed, 06 Jun 2007 17:34:16 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
>>>
>>>> Mikael Pettersson napsal(a):
>>>>> On Wed, 06 Jun 2007 15:04:00 +0200, Jiri Slaby wrote:
>>>>>> Andrew Morton napsal(a):
>>>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
>>>>>> It freezes during bootup while searching for sata drives on sata_promise. There
>>>>>> were 2 issues with sata_promise in -rc4 IIRC, one was fixed, the latter remains
>>>>>> unresolved. Or, should be this solved too, Mikael, Tejun and is this yet
>>>>>> eanother problem? (In this case I'll post dmesg and co.)
>>>>> I know of only one sata_promise-specific issue in 2.6.22-rc4.
>>>>> Tejun's "sata_promise: use TF interface for polling NODATA commands"
>>>>> patch posted today fixes it.
>>>> It's in that -mm, so I think, this seems to be another problem.
>>> No, it wasn't in 2.6.22-rc4-mm1.
>> Huh, what did I smoke? Something rejects to patch and now I don't know what.
>>
>>> Here it is - please test?
>> Ok, this solves this problem, but LVM is broken. Seems similar to
>> Re: 2.6.22-rc4-mm1 - 'lvm vgscan' busticated again...
>> Message-ID: <7929.1181146132@turing-police.cc.vt.edu>
>> Will try to play with this.
> 
> Did -rc3-mm1 work?

Yes. Now I'm compiling -rc4-mm2.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E


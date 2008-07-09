Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbYGIWfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbYGIWfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbYGIWe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:34:56 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:33608 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756476AbYGIWe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:34:56 -0400
Message-ID: <48753CFF.7000209@acm.org>
Date: Wed, 09 Jul 2008 16:34:39 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.26-rc8-mm1 - Missing AC97 power save Kconfig?
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>	<48752EB2.8050406@acm.org> <20080709150512.3b3bfdcf.randy.dunlap@oracle.com>
In-Reply-To: <20080709150512.3b3bfdcf.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080709/1KGiFD-0004wD-QC-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Wed, 09 Jul 2008 15:33:38 -0600 Zan Lynx wrote:
> 
>> Andrew Morton wrote:
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc8/2.6.26-rc8-mm1/
>>>
>>> - Seems to work on my x86 test boxes.  It does emit a
>>>   sleeping-while-atomic warning during exit from an application which
>>>   holds mlocks.  Known problem.
>>>
>>> - It's dead as a doornail on the powerpc Mac g5.  I'll bisect it later.
>> [cut]
>>
>> I don't know if this is well known, or why no one else noticed if it
>> isn't, but the AC97 power-save Kconfig option CONFIG_SND_AC97_POWER_SAVE
>> isn't in any of the Kconfig files.
> 
> Did you search for just /SND_AC97_POWER_SAVE/ ?  (no CONFIG_)

D'oh!  I feel dumb now.  Yes, it is in there.  Oddly, it is inside
Generic Devices, which my config has disabled, which somehow disabled
the option during "make oldconfig" that I *used* to have enabled in
older configs.

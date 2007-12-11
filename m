Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbXLKKsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbXLKKsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 05:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbXLKKsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 05:48:09 -0500
Received: from mailout06.sul.t-online.de ([194.25.134.19]:55259 "EHLO
	mailout06.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186AbXLKKsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 05:48:07 -0500
Message-ID: <475E6A99.1050800@t-online.de>
Date: Tue, 11 Dec 2007 11:46:49 +0100
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       penguin-kernel@I-love.SAKURA.ne.jp, linux-kernel@vger.kernel.org,
       Greg Ungerer <gerg@snapgear.com>, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Add EXPORT_SYMBOL(ksize);
References: <200712021743.GBH12983.FHOFVJOMFLOStQ@I-love.SAKURA.ne.jp> <20071202134841.GI15974@stusta.de> <20071203153459.ac19dae3.akpm@linux-foundation.org> <20071206210248.GN15974@stusta.de>
In-Reply-To: <20071206210248.GN15974@stusta.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ID: ZwwTWGZGgh2YoB6WnjfW9epu44DYLKSXTTBLs8uYgarSVoNlWFyarNjps+2EcQvQfM
X-TOI-MSGID: ba593c06-2ad3-4316-8169-e80c5634a42e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of Cc:s added.

Adrian Bunk wrote:
> On Mon, Dec 03, 2007 at 03:34:59PM -0800, Andrew Morton wrote:
>> On Sun, 2 Dec 2007 14:48:42 +0100
>> Adrian Bunk <bunk@kernel.org> wrote:
>>
>>> On Sun, Dec 02, 2007 at 05:43:39PM +0900, Tetsuo Handa wrote:
>>>> mm/slub.c exports ksize(), but mm/slob.c and mm/slab.c don't. I don't know why.
>>>> ...
>>> That's due to the fact that my patch to remove this unused export from 
>>> slub was not yet applied...
>>>
>>> Where is the modular in-kernel user?
>>>
>> binfmt_flat.c, binfmt_elf_fdpic.c.
> 
> I could have sworn I had checked that both are bools, but BINFMT_FLAT is 
> actually a tristate.
> 
> Is anyone actually using binfmt_flat modular (considering it's only 
> available for !MMU embedded systems)? If yes, then only exporting 
> ksize() will not be enough for getting it working modular...

We're not using modular binfmt_flat on the Blackfin, but I can't speak
for other architectures.


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif

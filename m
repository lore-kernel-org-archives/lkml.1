Return-Path: <linux-kernel-owner+w=401wt.eu-S1761551AbXESNbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551AbXESNbL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 09:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbXESNa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 09:30:58 -0400
Received: from neon.samage.net ([85.17.153.66]:50143 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbXESNa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 09:30:57 -0400
Message-ID: <1658.81.207.0.53.1179581454.squirrel@secure.samage.net>
In-Reply-To: <200705191525.36840.arvidjaar@mail.ru>
References: <200705191443.27161.arvidjaar@mail.ru>
    <6bffcb0e0705190400s67527883l3f2e2e1f36f4a359@mail.gmail.com>
    <200705191525.36840.arvidjaar@mail.ru>
Date: Sat, 19 May 2007 15:30:54 +0200 (CEST)
Subject: Re: 2.6.22-rc2: section mismatch
From: "Indan Zupancic" <indan@nul.nu>
To: "Andrey Borzenkov" <arvidjaar@mail.ru>
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20070519153054_89677"
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 93cd3d86cb1a6c73192de073a1923dc0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20070519153054_89677
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Sat, May 19, 2007 13:25, Andrey Borzenkov wrote:
> On Saturday 19 May 2007, Michal Piotrowski wrote:
>> Hi Andrey,
>>
>> On 19/05/07, Andrey Borzenkov <arvidjaar@mail.ru> wrote:
>> >   MODPOST vmlinux
>> > WARNING: init/built-in.o - Section mismatch: reference to .init.text:
>> > from .text between 'rest_init' (at offset 0x11b) and 'try_name'
>> > WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference
>> > to .init.text:amd_init_mtrr from .text between 'mtrr_bp_init' (at offset
>> > 0x967a) and 'mtrr_attrib_to_str'
>> > WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference
>> > to .init.text:cyrix_init_mtrr from .text between 'mtrr_bp_init' (at
>> > offset 0x967f) and 'mtrr_attrib_to_str'
>> > WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference
>> > to .init.text:centaur_init_mtrr from .text between 'mtrr_bp_init' (at
>> > offset 0x9684) and 'mtrr_attrib_to_str'
>> > WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference
>> > to .init.text: from .text between 'get_mtrr_state' (at offset 0xa735)
>> > and 'generic_get_mtrr'
>> > WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference
>> > to .init.text: from .text between 'get_mtrr_state' (at offset 0xa749)
>> > and 'generic_get_mtrr'
>> > WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference
>> > to .init.text: from .text between 'get_mtrr_state' (at offset 0xa770)
>> > and 'generic_get_mtrr'
>> > WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from
>> > .text between 'kmem_cache_create' (at offset 0x1bffd) and 'cache_reap'
>> > WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from
>> > .text between 'kmem_cache_create' (at offset 0x1c232) and 'cache_reap'
>>
>> Please send your .config file.
>>

I get the same warnings as Andrey (also the undefined symbols warnings,
but that's a different case).

As my config is 700 lines shorter, I've attached it too.

Greetings,

Indan

------=_20070519153054_89677
Content-Type: application/gzip; name=".config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=".config.gz"

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
------=_20070519153054_89677--



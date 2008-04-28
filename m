Return-Path: <linux-kernel-owner+w=401wt.eu-S936325AbYD1Q22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936325AbYD1Q22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934694AbYD1Q2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:28:19 -0400
Received: from trillian.zoopnet.de ([85.214.111.199]:52260 "EHLO
	trillian.zoopnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933657AbYD1Q2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:28:18 -0400
Message-ID: <4815FB1D.80209@zoopnet.de>
Date: Mon, 28 Apr 2008 18:28:13 +0200
From: Mika Fischer <mika.fischer@zoopnet.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
   layout v2
References: <200804272337.40130.yhlu.kernel@gmail.com>	<200804280206.52641.yhlu.kernel@gmail.com>	<20080428130826.GH27997@elte.hu> <20080428064925.318659b9@laptopd505.fenrus.org> <4815ED15.3080702@zoopnet.de> <4815F4F6.1030708@googlemail.com>
In-Reply-To: <4815F4F6.1030708@googlemail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C schrieb:
>> Ah, so the new X will be able to use the video memory in write-combining
>> mode even if I have an MTRR saying this area is uncachable or write-back?
>>
>> If that is the case, then I agree that this patch is not really needed.

It seems not to be the case, so this is moot anyway :)

> I doubt there will be any usable Xorg release soon.
> And I doubt peoples will run Xorg , mesa , etc master HEAD to have that feature. 
> 
> I think this patch is needed for now but as Ingo said , it should not be default.
> Peoples with these sort problems could boot with some option to enables this workaround.

Well, if it is compiled but inactive by default and can be enabled with
a kernel boot option, this is fine too.

But if it's a compile-time option, I doubt that any distro-kernel would
touch it if it's really dangerous. They're probably more likely to
backport the Xorg stuff if the new Xorg does not get finished in time.

Regards,
 Mika

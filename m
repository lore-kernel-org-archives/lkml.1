Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbZKZIDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbZKZIDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759261AbZKZIDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:03:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58704 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227AbZKZIDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:03:30 -0500
Date: 26 Nov 2009 08:28:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: kraxel@redhat.com
Cc: awalls@radix.net
Cc: dheitmueller@kernellabs.com
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: khc@pm.waw.pl
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BDcbfiXJjFB@christoph>
In-Reply-To: <4B0DBC2D.1010603@redhat.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+gxgXM+0xegN/RB87FOUZXjcnvg0f2tD2ZT2Q
 US9Sw4JIAIur9xT8ynnZfyWdCiCfGfTWLImpw26hpdiG1m6CN6
 UrWEJBid0KlVv8rocUzaQdb5r2CQidA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerd,

on 26 Nov 09 at 00:22, Gerd Hoffmann wrote:
[...]
>> To sum it up: I don't think this information will be useful at all for
>> lircd or anyone else.
[...]
> I know that lircd does matching instead of decoding, which allows to
> handle unknown encodings.  Thats why I think there will always be cases
> which only lircd will be able to handle (using raw samples).
>
> That doesn't make attempts to actually decode the IR samples a useless
> exercise though ;)

Well, in my opinion it is kind of useless. I don't see any use case or any  
demand for passing this kind of information to userspace, at least in the  
LIRC context.
If there's no demand, why bother?

Christoph

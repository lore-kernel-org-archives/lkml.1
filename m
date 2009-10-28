Return-Path: <linux-kernel-owner+w=401wt.eu-S932712AbZJ1Iab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712AbZJ1Iab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 04:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932656AbZJ1Iaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 04:30:30 -0400
Received: from borg.medozas.de ([188.40.89.202]:60157 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932652AbZJ1Iaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 04:30:30 -0400
Date: Wed, 28 Oct 2009 09:30:33 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Yuhong Bao <yuhongbao_386@hotmail.com>
cc: macro@linux-mips.org, davej@redhat.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Subject: RE: [X86] Fix up silly i1586 boot message.
In-Reply-To: <SNT125-W471F856F2358A53E59A13BC3B80@phx.gbl>
Message-ID: <alpine.LSU.2.00.0910280914590.28170@obet.zrqbmnf.qr>
References: <20080528165713.GA412@redhat.com> <alpine.LNX.1.10.0805281943330.19264@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.55.0805281850540.29522@cliff.in.clinika.pl> <alpine.LNX.1.10.0805282001180.19264@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.55.0805281916480.29522@c
 <SNT125-W471F856F2358A53E59A13BC3B80@phx.gbl>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2009-10-28 04:08, Yuhong Bao wrote:
> <Pine.LNX.4.55.0805290102340.29522@cliff.in.clinika.pl>
>
>> Intel started it first with picking up a ridiculous number for the family
>> ID for the P4 line. There is no technical justification for not keeping
>> these numbers consecutive.

Once one knows that there are 4 bits for the family field, 15 is not
such a strange value - it is the last value, one could take it as
"reserved, and look elsewhere".

>[...] Intel has assigned family 7 for the original Itanium processor
>[...] there was a bug in original NT 4 truncating family IDs
>returned by CPUID [...]

That would explain why Intel still shows an oldfashioned family=6 on
many contemporary processors (e.g. core i7). BUT, AMD64 processors
have family=15 "almost throughout", and so seem to have at least some
Intel models. So that tells us that either NT4 works, or nobody uses
NT4 on fam15s.

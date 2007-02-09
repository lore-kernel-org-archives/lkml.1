Return-Path: <linux-kernel-owner+w=401wt.eu-S1946426AbXBIMbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946426AbXBIMbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:31:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946424AbXBIMbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:31:09 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:60426 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946426AbXBIMbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:31:07 -0500
Date: Fri, 9 Feb 2007 13:27:01 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andi Kleen <ak@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Frederik Deweerdt <deweerdt@free.fr>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: -mm merge plans for 2.6.21
In-Reply-To: <p73ps8j1nzx.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.61.0702091320310.31955@yvahk01.tjqt.qr>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
 <Pine.LNX.4.61.0702090023270.24888@yvahk01.tjqt.qr> <20070209105737.GF5785@slug>
 <1171020273.8675.150.camel@laptopd505.fenrus.org>
 <20070209033936.41be141b.akpm@linux-foundation.org> <p73ps8j1nzx.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 9 2007 14:04, Andi Kleen wrote:
>Andrew Morton <akpm@linux-foundation.org> writes:
>> 
>> As long as nobody takes the address of them (which wouldn't compile today
>> anyway) then the compiler should be able to not allocate store for these. 
>
>This would only work for unit-at-a-time compilers (if it works at all,
>i'm not sure), but not older 3.x compilers
>
>> That they're const might help too.
>
>Don't think it does.

GCC 4.1 optimizes both Andrew's and Frederik Deweerdt's ideas 
perfectly out. Even if the const was not there in Frederik's example, 
gcc seems throw it out with -O2 (judging by `nm` output) since it is
1. static 2. unused. Gcc even gives out a warning that the item is 
unused when not marked with const.


Jan
-- 
ft: http://freshmeat.net/p/chaostables/

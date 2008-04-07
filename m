Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbYDGXL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbYDGXL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 19:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbYDGXLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 19:11:51 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:39602
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbYDGXLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:11:50 -0400
Message-ID: <47FAAA10.4030509@qumranet.com>
Date: Tue, 08 Apr 2008 02:11:12 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc8-git5: Reported regressions from 2.6.24
References: <200804071459.35628.rjw@sisk.pl>
In-Reply-To: <200804071459.35628.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10172
> Subject		: kvm: INFO: inconsistent lock state
> Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> Date		: 2008-03-05 03:26 (34 days old)
>
>   

This is benign; will fix, likely post 2.6.25 as the fix in non trivial.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10156
> Subject		: KVM &amp; Qemu crashed with infinite recursive kernel loop in the guest
> Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> Date		: 2008-02-28 11:25 (40 days old)
> References	: http://lkml.org/lkml/2008/2/28/106
>
>   

Marcelo fixed this a few days ago; I'll post my 2.6.25 queue soon.

Can you bcc subsystem maintainers with entries on this list?  Or perhaps 
those that opt-in?

-- 
Any sufficiently difficult bug is indistinguishable from a feature.


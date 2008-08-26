Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbYHZQRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbYHZQRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYHZQQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:16:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51284 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbYHZQQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:16:54 -0400
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Avi Kivity <avi@qumranet.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
From: Andi Kleen <andi@firstfloor.org>
References: <1219659087-17536-1-git-send-email-avi@qumranet.com>
	<20080826095032.GA309@elf.ucw.cz> <48B3D579.40502@qumranet.com>
	<20080826113317.520cbab1@lxorguk.ukuu.org.uk>
	<48B3F3A9.8030709@qumranet.com>
	<Pine.LNX.4.55.0808261406330.28361@cliff.in.clinika.pl>
Date: Tue, 26 Aug 2008 18:16:42 +0200
In-Reply-To: <Pine.LNX.4.55.0808261406330.28361@cliff.in.clinika.pl> (Maciej W. Rozycki's message of "Tue, 26 Aug 2008 14:24:20 +0100 (BST)")
Message-ID: <87fxorsqdx.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Maciej W. Rozycki" <macro@linux-mips.org> writes:

> On Tue, 26 Aug 2008, Avi Kivity wrote:
>
>> Most machines are recent machines.
>
>  This is a bold statement I would say.  Any numbers to back it up?

You can do the math. Reasonable assumptions are ~10% growth rate
in year-by-year units shipment (that's conservative, usually it is higher) 
and that most systems are only used for 4-5 years (on commercial servers 
it's typically 4 years, on privately used systems perhaps a bit more,
laptops certainly less because they tend to break earlier). That 
is the average, of course there are systems which are used much
longer (or much shorter), but I would expect them to be the minority.

Also laptops are growing more and more compared to desktops (iirc the
cross over of more laptops than desktops shipping happened recently)
and if the assumption that they break earlier is true (it is
definitely in my experience) so it's likely that the average system
live time shrinks in the future.

With that it's reasonably easy to show that most systems are recent,
if you define recent as 1-3 years. The "ACPI is the standard validated
mode of operation" window is more like 7-8 years by now. With that
I would expect the systems with very poor ACPI implementation to
be a small minority by now.

-Andi

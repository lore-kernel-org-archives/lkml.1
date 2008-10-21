Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbYJUJnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbYJUJnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 05:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYJUJnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 05:43:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43459 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYJUJnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 05:43:31 -0400
To: akataria@vmware.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Dan Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 0/3] Improve TSC as a clocksource under VMware
From: Andi Kleen <andi@firstfloor.org>
References: <1224552902.2640.88.camel@alok-dev1>
Date: Tue, 21 Oct 2008 11:43:30 +0200
In-Reply-To: <1224552902.2640.88.camel@alok-dev1> (Alok Kataria's message of "Mon, 20 Oct 2008 18:35:02 -0700")
Message-ID: <874p36fflp.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria <akataria@vmware.com> writes:

> This patch set makes some changes to the TSC code, so that it is always
> used as the default clocksource when running under VMware.

Does this imply that vmware always emulates TSC reads?
Or how do you guarantee reliable TSC on a system where the underlying
TSC isn't?

It would be far nicer if VMware just emulated the "constant_tsc" bit
in the AMD CPUID leaf, instead of adding all that gunk to Linux.
Right now it's only checked for AMD CPUs, but that could be changed.

Otherwise with more and more hypervisors we mind end up with more
and more unscalable detection code.

-Andi

-- 
ak@linux.intel.com

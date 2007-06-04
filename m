Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbXFDVDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbXFDVDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXFDVCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:02:53 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47123 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbXFDVCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:02:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan>
	<200706011407.51779.jbarnes@virtuousgeek.org>
	<20070601211943.GO7217@one.firstfloor.org>
	<200706011441.57149.jbarnes@virtuousgeek.org>
	<m1r6orwptz.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0706041420100.25811@p34.internal.lan>
	<20070604201823.7b7cb328@the-village.bc.nu>
Date: Mon, 04 Jun 2007 15:01:50 -0600
In-Reply-To: <20070604201823.7b7cb328@the-village.bc.nu> (Alan Cox's message
	of "Mon, 4 Jun 2007 20:18:23 +0100")
Message-ID: <m1myzfwi0x.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> Therefore, they are NOT going to fix their BIOS-- and I have already 
>> received an e-mail from one or two people who are experiencing this 
>> problem, I presume it will only get worse.
>
> In which case we need to clip the memory used according to the MTRR
> registers and tell the user xxMB of memory not available due to BIOS bugs

Exactly, and given that this is a fairly easy thing to do, and that
occasionally we see systems where this happens (even if their BIOS is
later fixed).  It is likely worth it for someone to write up the patch
and that compare MTRRs with available memory, and to complain and
reserve all memory that MTRRs claim is not write-back.

Eric

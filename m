Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbZIBC36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbZIBC36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 22:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZIBC36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 22:29:58 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:51905 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbZIBC35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 22:29:57 -0400
X-Greylist: delayed 768 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Sep 2009 22:29:57 EDT
Date: Wed, 2 Sep 2009 03:17:08 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Question] x86,APIC: In apicdef.h dfr,svr,...... shouldn't be
 const?
In-Reply-To: <b9df5fa10908312248x6a8946f5jfbe972f3358baad3@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0909020308510.27310@eddie.linux-mips.org>
References: <b9df5fa10908312248x6a8946f5jfbe972f3358baad3@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009, Rakib Mullick wrote:

> Hello guys, Intel System programmers guide says - dfr, svr, esr - this
> registers should be readonly. So shouldn't they use const? Or is it
> anything else?

 All the three have meaningful semantics on writes at least on some 
versions of the APIC (they either have writable fields or trigger side 
effects on writes).  It looks like your documentation is wrong (not 
unheard of with Intel).

  Maciej

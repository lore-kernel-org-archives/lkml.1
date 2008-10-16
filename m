Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbYJPGkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbYJPGkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYJPGkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:40:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45485 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbYJPGkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:40:08 -0400
Message-ID: <48F6E1A7.2070602@zytor.com>
Date: Wed, 15 Oct 2008 23:39:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jike Song <albcamus@gmail.com>
CC: gcosta@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: questions about rd{msr|tsc|pmc} instruction with x86-64
References: <df9815e70810152330h7886c77arb01e1fd308b4a7ae@mail.gmail.com>
In-Reply-To: <df9815e70810152330h7886c77arb01e1fd308b4a7ae@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jike Song wrote:
> 
> By my reading of Intel & AMD manuals, this comment is wrong.  rdmsr of
> x86-64 has the same behavior as i386, namely the high 32bit returns in
> edx and the low 32bit in eax, not "returns at rax".  And the gcc
> constraint "A" does mean edx:eax in x86-64 also, at least when testing
> on my AMD Turion 64 processor.
> 

"A" means rdx:rax on x86-64, not edx:eax.  For a 64-bit number, it 
means, literally, "one of rdx or rax"!  As you correctly point out, this 
is not how rdmsr works.

	-hpa

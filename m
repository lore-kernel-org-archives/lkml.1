Return-Path: <linux-kernel-owner+w=401wt.eu-S1759780AbXEQBzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780AbXEQBzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 21:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757793AbXEQBzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 21:55:32 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33474 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbXEQBzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 21:55:31 -0400
Message-ID: <464BB60B.8060207@zytor.com>
Date: Wed, 16 May 2007 18:55:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Christian <haveaniceday@cv-sv.de>,
       linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <464BACCC.7070504@zytor.com>
In-Reply-To: <464BACCC.7070504@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> Andi added code to verify that we can actually execute on the processor
> before protected mode (so we can still get a message out through the
> BIOS.)  That code presumably doesn't know of the MSR that needs to be
> touched.
> 
> That code is in assembly in Andi's version, my rewritten version has it
> in C.  I should add this code.
> 

The newsetup tree now has code to unmask features on VIA and Transmeta
(as well as AMD, which was already in there):

http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-newsetup.git;a=commitdiff;h=c9cf55604433b386d0b499ed7bed654fd01c3be2

	-hpa

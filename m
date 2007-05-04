Return-Path: <linux-kernel-owner+w=401wt.eu-S1030923AbXEDPug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030923AbXEDPug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030945AbXEDPuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:50:35 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33822 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030923AbXEDPue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:50:34 -0400
Message-ID: <463B5643.1040204@zytor.com>
Date: Fri, 04 May 2007 08:50:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: always clear bss
References: <463AED07.1000505@goop.org> <m1r6pwu806.fsf@ebiederm.dsl.xmission.com> <463B49F0.401@goop.org>
In-Reply-To: <463B49F0.401@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Yes, that's more or less the same code, aside from using 0x40(%esi) as a
> stack.  Would that be OK here?
> 

I saw the 0x40(%esi) stack stuff, and I'm utterly puzzled by it.  There
is no reason one can't set up %esp to point to a hunk in ordinary memory
and use it?

	-hpa

Return-Path: <linux-kernel-owner+w=401wt.eu-S933104AbXEDP0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbXEDP0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbXEDP0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:26:00 -0400
Received: from gw.goop.org ([64.81.55.164]:35167 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104AbXEDPZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:25:59 -0400
Message-ID: <463B508A.2030307@goop.org>
Date: Fri, 04 May 2007 08:26:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: always clear bss
References: <463AED07.1000505@goop.org>	<m1r6pwu806.fsf@ebiederm.dsl.xmission.com> <463B49F0.401@goop.org> <m13b2csjeg.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m13b2csjeg.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Using 0x40 as a stack would be ok.
>   

OK.

> There are issues with CONFIG_RELOCATABLE and V!=P that I'm not
> comfortable with yet, because we can't tell the difference.

But it doesn't matter in this case, does it?  It just needs to find the
current address, whether it be virtual or physical, of the bss.  It
doesn't assume any particular offset.

When does the relocation happen?   Does the bzImage loader do it as part
of decompression?  Or does the kernel do it to itself?  (Not that it
makes any difference here.)

    J

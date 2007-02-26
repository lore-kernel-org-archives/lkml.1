Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbXBZXfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbXBZXfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXBZXfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:35:05 -0500
Received: from terminus.zytor.com ([192.83.249.54]:40856 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbXBZXfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:35:03 -0500
Message-ID: <45E36D76.5030507@zytor.com>
Date: Mon, 26 Feb 2007 15:29:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andreas Gruenbacher <a.gruenbacher@computer.org>,
       Nathan Scott <nathans@sgi.com>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: include/linux/xattr.h: how much userpace visible?
References: <20060723184343.GA25367@stusta.de> <20060724085701.B2083275@wobbly.melbourne.sgi.com> <200607242031.11815.a.gruenbacher@computer.org> <20060724184534.GA26842@mars.ravnborg.org>
In-Reply-To: <20060724184534.GA26842@mars.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> The userspace headers are supposed to hold the part of the kernel
> definitions that glibc (and mayby the attr package) uses. If they happen
> to have their own copy now should not impct the decision what is part of
> the userspace interface for the kernel. So actual usage does not decide
> what is part of the userspace kernel headers but what definitionas are
> definitions the userspace <-> kernel interface.

glibc, or another libc.

Basically, the kernel should be able to export the things that userspace 
needs to be able to correctly speak the ABI.

	-hpa

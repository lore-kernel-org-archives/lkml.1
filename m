Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbXJWWUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbXJWWUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbXJWWUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:20:30 -0400
Received: from gw.goop.org ([64.81.55.164]:36583 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbXJWWU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:20:29 -0400
Message-ID: <471E73AB.4050100@goop.org>
Date: Tue, 23 Oct 2007 15:20:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v7 1/3] x86 boot: setup data
References: <1193126771.23935.79.camel@caritas-dev.intel.com> <471E70E0.2090802@goop.org> <471E729F.3000105@zytor.com>
In-Reply-To: <471E729F.3000105@zytor.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> No, he doesn't.  The boot protocol version is communication between
> the boot loader and the kernel (specifically, it is communication FROM
> the kernel TO the bootloader), not between internal bits of the
> kernel.  Th

So the bootloader will only fill out fields the kernel claims to understand?

> Since the pointer is safely inside the setup template, even if the
> bootloader doesn't understand boot protocol version 2.08 it will have
> copied it.


OK.

    J

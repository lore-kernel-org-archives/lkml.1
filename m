Return-Path: <linux-kernel-owner+w=401wt.eu-S1946335AbXEADi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946335AbXEADi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946338AbXEADi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:38:28 -0400
Received: from terminus.zytor.com ([192.83.249.54]:56830 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946335AbXEADi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:38:27 -0400
Message-ID: <4636B626.5040702@zytor.com>
Date: Mon, 30 Apr 2007 20:38:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Dave Jones <davej@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <20070501015115.GJ26601@redhat.com> <4636A332.2070101@zytor.com> <m1odl51dci.fsf@ebiederm.dsl.xmission.com> <20070501034612.GK25929@bingen.suse.de> <4636ABE3.5070502@zytor.com> <20070501042939.GM25929@bingen.suse.de>
In-Reply-To: <20070501042939.GM25929@bingen.suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> At least my Asus board with 8Mb flash doesn't have anything called that.
> There is also no special preboot environment
> 
> iirc Asus ships dual BIOS though, but even half that compressed is a lot.
> 

8 Mb or 8 MB?  Big difference...

So you have 512K worth of compressed code, most of which is running the
configuration menus and code to do initialization and setup of the
runtime environment (build tables, and so on.)  That's not really BIOS,
per se, in the sense of an interface; any firmware has to do that stuff
no matter what.

	-hpa

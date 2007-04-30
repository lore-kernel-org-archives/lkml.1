Return-Path: <linux-kernel-owner+w=401wt.eu-S1422958AbXD3Ely@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422958AbXD3Ely (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 00:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422969AbXD3Ely
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 00:41:54 -0400
Received: from ozlabs.org ([203.10.76.45]:55860 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422958AbXD3Elx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 00:41:53 -0400
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
	relocatable bzImage
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4634483E.9030307@goop.org>
References: <20070428758.455116000@suse.de>
	 <20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
	 <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com>  <4634483E.9030307@goop.org>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 14:41:18 +1000
Message-Id: <1177908078.30071.206.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 00:24 -0700, Jeremy Fitzhardinge wrote:
> Is it possible to decompress and extract the kernel image from the
> bzImage without executing it?  Ie, is there enough information to find
> the compressed data part of the bzImage by inspection?
> 
> At some point we'll need to change the Xen domain builder to handle
> bzImage files, and it would be best if we didn't need to run them.

Almost.  See lguest's launcher code: load_bzimage().  You'll hate it 8)

Rusty.



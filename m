Return-Path: <linux-kernel-owner+w=401wt.eu-S1423640AbXD3QE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423640AbXD3QE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423634AbXD3QE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:04:57 -0400
Received: from terminus.zytor.com ([192.83.249.54]:37752 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423619AbXD3QEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:04:16 -0400
Message-ID: <46361341.1050806@zytor.com>
Date: Mon, 30 Apr 2007 09:03:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>	<1177902195.30071.203.camel@localhost.localdomain>	<463572B7.90202@zytor.com>	<1177909434.30071.216.camel@localhost.localdomain> <m1d51m77ry.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1d51m77ry.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> Sure.
> 
> Peter do we want to use the bootloader byte and assign lguest it's own
> bootloader type or do we want to add another field specific to 
> paravirtualized environments?
> 

The bootloader byte is already a bit too overused; I'm a little scared
that we're going to run out of boot loader IDs as it is.

We probably should add another field, and while we're at it maybe we
should add a boot loader extension field.

	-hpa

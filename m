Return-Path: <linux-kernel-owner+w=401wt.eu-S935918AbXFGBzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935918AbXFGBzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 21:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764962AbXFGBzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 21:55:06 -0400
Received: from terminus.zytor.com ([192.83.249.54]:60259 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759462AbXFGBzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 21:55:05 -0400
Message-ID: <46676552.4060308@zytor.com>
Date: Wed, 06 Jun 2007 18:54:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 6/7] i386: make the bzImage payload an ELF file
References: <20070606225837.654272428@goop.org> <20070606230922.476662240@goop.org> <4667462A.2010404@zytor.com> <200706062147.21225.rob@landley.net>
In-Reply-To: <200706062147.21225.rob@landley.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> On Wednesday 06 June 2007 7:41 pm, H. Peter Anvin wrote:
>> This makes vmlinux (normally stripped) recoverable from the bzImage file
>> and so anything that is currently booting vmlinux would be serviced by
>> this scheme.
> 
> Would this make it sane to strip the initramfs image out of vmlinux with 
> objdump and replace it with another one, or are there offsets resolved during 
> the build that stop that for vmlinux?
> 

There probably are offsets resolved during the build.  However, that
wouldn't be all that hard to fix.  Still, one can argue whether or not
it is sane under any definition to do this kind of unpacking-repacking
of ELF files.

	-hpa


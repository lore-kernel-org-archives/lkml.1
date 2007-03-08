Return-Path: <linux-kernel-owner+w=401wt.eu-S1752266AbXCHGSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbXCHGSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 01:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbXCHGSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 01:18:01 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33475 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbXCHGSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 01:18:00 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: vgoyal@in.ibm.com
Cc: Sam Ravnborg <sam@ravnborg.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, akpm@linux-foundation.org,
       ak@suse.de, hpa@zytor.com, magnus.damm@gmail.com, lwang@redhat.com,
       dzickus@redhat.com, pavel@suse.cz, rjw@sisk.pl
Subject: Re: [PATCH 1/20] x86_64: Assembly safe page.h and pgtable.h
References: <20070307065703.GA23412@in.ibm.com>
	<20070307065920.GB23412@in.ibm.com>
	<20070307192404.GA31826@uranus.ravnborg.org>
	<20070308060139.GJ6000@in.ibm.com>
Date: Wed, 07 Mar 2007 23:16:30 -0700
In-Reply-To: <20070308060139.GJ6000@in.ibm.com> (Vivek Goyal's message of
	"Thu, 8 Mar 2007 11:31:39 +0530")
Message-ID: <m1d53k8dkx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@in.ibm.com> writes:

> Hi Sam,
>
> Thanks for the review. This makes sense to me. Move const.h into
> asm-generic and let everybody use it.
>
> This is more of a small cleanup issue and involves changing few header files
> in asm-sparc64 and make sure nothing is broken on sparc64. This patchset
> is already becoming big and complex. Is it ok if we let the patch 
> remain unmodified for now and once this gets in and settles down, I can
> post another patch to do above modification?

Actually unless there is a reason not to, we can probably move this
into include/linux instead of include/asm-generic.  I don't see anything
in that header file that is architecture specific in any way.  Except
that it happens to only be used in architecture specific code.

Eric

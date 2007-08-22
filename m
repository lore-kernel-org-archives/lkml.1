Return-Path: <linux-kernel-owner+w=401wt.eu-S1764707AbXHVPh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764707AbXHVPh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763712AbXHVPhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:37:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54174 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763747AbXHVPhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:37:47 -0400
Date: Wed, 22 Aug 2007 08:36:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1: cannot stat `vdso.so.dbg'
Message-Id: <20070822083650.85fdfcea.akpm@linux-foundation.org>
In-Reply-To: <20070822102434.D82B84D04B2@magilla.localdomain>
References: <20070822101529.GE7228@localhost.sw.ru>
	<20070822102434.D82B84D04B2@magilla.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 03:24:34 -0700 (PDT) Roland McGrath <roland@redhat.com> wrote:

> That is fixed by the later version of the vdso-install patches I sent later.
> I thought Andrew had already incorporated the fixed versions.
> 

Those patches are in Andi's tree.  His tree has the old versions.  The
patches are inter-tangled so it is non-trivial for me to generate
incremental patches on top of Andi's tree which bring his old patches up to
date with the new ones.  I could of course do so, but it'd be better if
Andi's tree weren't carrying old versions of
x86_64-ia32-vdso-install-unstripped-copies-on-disk and
x86_64-vdso-install-unstripped-copies-on-disk

Please resend those patches to Andi.

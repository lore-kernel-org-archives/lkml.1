Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbYIGUIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbYIGUIQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 16:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYIGUIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 16:08:00 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:33401 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbYIGUH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 16:07:59 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Date: Sun, 7 Sep 2008 16:07:52 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
References: <200808311422.12525.linux@sandersweb.net> <48C1C156.9080003@zytor.com>
In-Reply-To: <48C1C156.9080003@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809071607.52645.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2008 19:31, H. Peter Anvin wrote:
> David Sanders wrote:
> > I recently discovered that x86 kernels won't boot under Virtual PC.  In
> > this case paravirt was not built into the kernel.  The kernel just
> > "hangs" on attempted boot with no error messages.  Git-bisect pinpointed
> > the following commit as the problem:
>
> Hi David,
>
> Could you please confirm if the tip kernel solves the problem?
>
> Either that or apply this patch series to mainline; I'd like to promote
> this to urgent and send it to Linus for inclusion in 2.6.27, but I need
> verification as quickly as possible.
>
> 	-hpa
Peter, sorry about delay in replying I was out of town for weekend.  I will 
apply your patch and git back to you on results.  A quick look a the patches 
indicates that nop.h and the users of nop.h are not addressed so I may have 
to combine your patches with Linus's Kconfig patch to get a working kernel.
David



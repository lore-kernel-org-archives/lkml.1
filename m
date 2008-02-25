Return-Path: <linux-kernel-owner+w=401wt.eu-S1759056AbYBYUiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056AbYBYUiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbYBYUiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:38:05 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:35909 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbYBYUiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:38:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=baa1TK8d/zLOldxQ7ldBrIj1HAM8GRG0NKShAFZTtl37QygClAhi4tIP5Ijd55xeIyluHSJyCDNksYy/UTtYjXlhbSUieOK7tydg+t0whetAZsGPCKYK5eUe5GfCUml5zJwpU9nObFKrSTEjLxgPHUpBQ5/0p6SnZ9iXDSw2et8=
Message-ID: <19f34abd0802251237q2aa5db03s522c77340cdc96a@mail.gmail.com>
Date: Mon, 25 Feb 2008 21:37:57 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: compile problem in current x86.git
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <47C315CC.5020001@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47C315CC.5020001@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Mon, Feb 25, 2008 at 8:23 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   CC      arch/x86/kernel/traps_32.o
>  /home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/traps_32.c:59:27: error: asm/kmemcheck.h: No such file or directory
>
>
>  asm-x86/kmemcheck.h does seem to be completely missing.  Looks like
>  8db0acefb3025795abe3f37669354677a03de680 "x86: add hooks for kmemcheck"
>  should have added the file.

Hm. This is x86#testing, no? I don't think there's any kmemcheck code
whatsoever in other branches.

The file should be added with this commit:

kmemcheck: add the kmemcheck core
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commit;h=c83d05d69382945c92a2e7a2b168c1cc2aa77c29


Vegard

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYGDCUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYGDCUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 22:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbYGDCUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 22:20:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742AbYGDCUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 22:20:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Nathan Lynch <ntl@pobox.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/2] elf loader support for auxvec base platform string
In-Reply-To: Nathan Lynch's message of  Thursday, 3 July 2008 18:41:40 -0500 <20080703234140.GC9594@localdomain>
References: <20080703234140.GC9594@localdomain>
X-Shopping-List: (1) Teutonic Inelegant removal stones
   (2) Cadaverous burgers
   (3) Asymmetrical insufficient deception bears
   (4) Virtuous cushion contributions
   (5) Typical eggplants
Message-Id: <20080704021929.5E9EF1541F5@magilla.localdomain>
Date: Thu,  3 Jul 2008 19:19:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why not just use ELF_HWCAP for this?  It looks like powerpc only has 3 bits
left there (keeping it to 32), but 3 is not 0.  If not that, why not use
dsocaps?  That is, some magic in the vDSO, which glibc already supports on
all machines where it uses the vDSO.  (For how it works, see the use in
arch/x86/vdso/vdso32/note.S for CONFIG_XEN.)


Thanks,
Roland

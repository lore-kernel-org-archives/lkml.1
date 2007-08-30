Return-Path: <linux-kernel-owner+w=401wt.eu-S1761431AbXH3O0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761431AbXH3O0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756957AbXH3O0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:26:23 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:7197 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbXH3O0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ON4Xtdl8giQjzaPsb/X3T/Rvl2cgOtrjlLadF/8dOW7cBrVKIzrR936WqXH2TUVU58vyrxQH82JSB0FD8riQIu1SYEkyuijXHfQR+0zCIlQCMuydPHX1y/AsuAIdtiXKl4CXKT8vAndO/6KsYV5Xm+e4oIv2zQO1L9oKKj+2Qx8=
Message-ID: <8bd0f97a0708300726h563808a6j2b2ef9adf805c109@mail.gmail.com>
Date: Thu, 30 Aug 2007 10:26:22 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [PATCH] i386 and x86_64: randomize brk()
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708301620010.4135@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0708301545100.4135@jikos.suse.cz>
	 <8bd0f97a0708300701r1f36bc0anc45b9cad4a11f2ef@mail.gmail.com>
	 <Pine.LNX.4.64.0708301620010.4135@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/30/07, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 30 Aug 2007, Mike Frysinger wrote:
> > does it really make sense to stick stubs into no-mmu ports which cannot
> > utilize the ELF binfmt ?
>
> Good point, thanks. I have removed the stubs for h8300 and m68knommu.

Blackfin too please :)

i think v850 also falls into this category, but i'm not terribly
familiar with it ...
-mike

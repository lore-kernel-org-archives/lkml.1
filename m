Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbYAWQU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbYAWQU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYAWQUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:20:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38318 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbYAWQUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:20:18 -0500
Date: Wed, 23 Jan 2008 17:54:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: test case for the RODATA config option
Message-ID: <20080123165401.GA30749@one.firstfloor.org>
References: <20080122144420.4ebcf95f@laptopd505.fenrus.org> <p731w88nc0p.fsf@crumb.suse.de> <20080123064905.5d05509a@laptopd505.fenrus.org> <200801231627.28715.andi@firstfloor.org> <20080123080438.490b0c3e@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123080438.490b0c3e@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes internally that uses c-p-a, but there's more code there, including a set of boundary conditions etc.

You mean the ro boundary to the rest of the kernel and the 
rest of the kernel mappings on i386?

It doesn't seem to check for any of those.

> And for the page table to work, cr0 needs to be set up correctly etc etc etc.

If you really want to check that then you should run it on all CPUs
at least.

But ok given that it's already merged I'll shut up now since it's too
late.

-Andi


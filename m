Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYHAIf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYHAIf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 04:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbYHAIfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 04:35:17 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:13344 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbYHAIfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 04:35:15 -0400
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to
	convert
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080728200500.GA14284@uranus.ravnborg.org>
References: <20080728200500.GA14284@uranus.ravnborg.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Fri, 01 Aug 2008 10:35:12 +0200
Message-Id: <1217579712.10483.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 22:05 +0200, Sam Ravnborg wrote:
> So I have hacked up support for this in kbuild so
> for the simpler cases a simple move of header files as
> in:
> 	git mv include/asm-$ARCH arch/$ARCH/include/asm
> 
> is enough.

Just tested it on s390. We need a tiny fix for the qeth driver then it
works just fine (qeth has two includes for include/asm-s390 instead of
include/asm). I'll queue the qeth fix on git390. The only question is
who will do the move? 

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.



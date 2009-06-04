Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbZFDUOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbZFDUOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbZFDUOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:14:33 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:33819 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbZFDUOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:14:33 -0400
Date: Thu, 4 Jun 2009 22:16:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/6] headers_check fix: arm, hwcap.h
Message-ID: <20090604201649.GC13892@uranus.ravnborg.org>
References: <1244118232.5172.26.camel@ht.satnam> <1244118476.5172.29.camel@ht.satnam> <20090604125306.GC24491@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604125306.GC24491@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 01:53:07PM +0100, Russell King wrote:
> On Thu, Jun 04, 2009 at 05:57:56PM +0530, Jaswinder Singh Rajput wrote:
> > fix the following 'make headers_check' warning:
> 
> I think headers_check needs fixing - there's nothing wrong with the
> code as it presently stands except the tools obviously can't properly
> parse C preprocessor statements.

You are correct that headers_ceck is limited here and this patch
take some valid code and refactor it to make it headers_check compatible.

But the resulting code is as readable as before and
we keep the noise down when checking our exported headers.

Considering the effort needed to fix the tool I would request
you to take the patch anyway.

	Sam

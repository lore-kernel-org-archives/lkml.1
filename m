Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbYIAOHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbYIAOHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 10:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbYIAOG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 10:06:57 -0400
Received: from [198.99.130.12] ([198.99.130.12]:56722 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYIAOG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 10:06:56 -0400
Date: Mon, 1 Sep 2008 10:06:18 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, jiayingz@google.com,
       dkegel@google.com
Subject: Re: [PATCH 1/6] base: Valgrind headers and Kconfig
Message-ID: <20080901140618.GA5691@c2.user-mode-linux.org>
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net> <alpine.DEB.1.00.0808291613420.15543@abydos.NerdBox.Net> <87ljycxldb.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ljycxldb.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 11:32:00AM +0200, Andi Kleen wrote:
> Steve VanDeBogart <vandebo-lkml@NerdBox.Net> writes:
> > Kconfig option for Valgrind.  Suppression file, for known non-issues.
> > Valgrind header files (svn 8534) that define the client request
> > mechanism used to annotate programs plus a couple lines to integrate
> > with Kconfig.
> 
> Couldn't you just get the valgrind.h header from the currently
> installed valgrind? UML relies on host includes anyways, so
> I don't see a reason to not do that for valgrind too.

Kernel code can't get headers from the system, unless you're thinking
       #include "/usr/include/valgrind.h"
or something similar.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

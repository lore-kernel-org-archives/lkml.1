Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbYIAJcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbYIAJcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYIAJcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:32:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34718 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbYIAJcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:32:01 -0400
To: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       jiayingz@google.com, dkegel@google.com
Subject: Re: [PATCH 1/6] base: Valgrind headers and Kconfig
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
	<alpine.DEB.1.00.0808291613420.15543@abydos.NerdBox.Net>
Date: Mon, 01 Sep 2008 11:32:00 +0200
In-Reply-To: <alpine.DEB.1.00.0808291613420.15543@abydos.NerdBox.Net> (Steve VanDeBogart's message of "Fri, 29 Aug 2008 16:14:32 -0700 (PDT)")
Message-ID: <87ljycxldb.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve VanDeBogart <vandebo-lkml@NerdBox.Net> writes:

> Kconfig option for Valgrind.  Suppression file, for known non-issues.
> Valgrind header files (svn 8534) that define the client request
> mechanism used to annotate programs plus a couple lines to integrate
> with Kconfig.

Couldn't you just get the valgrind.h header from the currently
installed valgrind? UML relies on host includes anyways, so
I don't see a reason to not do that for valgrind too.

-Andi

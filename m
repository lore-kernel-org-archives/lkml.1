Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbXJIJjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbXJIJjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 05:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbXJIJj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 05:39:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbXJIJj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 05:39:27 -0400
To: Sam Ravnborg <sam@ravnborg.org>
Cc: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
References: <20071008200255.GA16497@uranus.ravnborg.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Oct 2007 11:39:21 +0200
In-Reply-To: <20071008200255.GA16497@uranus.ravnborg.org>
Message-ID: <p73sl4k4ofq.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> writes:
>  
> -ARCH		?= $(SUBARCH)
> -CROSS_COMPILE	?=

Can you do this in a way that there are still these ARCH/CROSS_COMPILE
lines that are just overriden when empty or have their default value? 

This way defaults could be still patched in for special cases.

-Andi

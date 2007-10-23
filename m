Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbXJWOBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbXJWOBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 10:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbXJWOBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 10:01:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:45845 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbXJWOBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 10:01:47 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Al Viro <viro@ftp.linux.org.uk>, WANG Cong <xiyou.wangcong@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Nix <nix@esperi.org.uk>,
       Jeff Dike <jdike@addtoit.com>, Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
From: Andi Kleen <andi@firstfloor.org>
References: <20071022074823.GJ2998@hacking>
	<20071022113600.GA8181@ftp.linux.org.uk>
	<20071022122504.GL2998@hacking>
	<20071022124322.GB8181@ftp.linux.org.uk>
	<20071022124551.GA7438@elte.hu> <471D2ECC.6090209@goop.org>
	<20071022231927.GA30814@elte.hu> <471D389E.40609@goop.org>
	<20071023084546.GA17007@elte.hu> <p73wste7zy5.fsf@bingen.suse.de>
	<20071023131009.GA32298@elte.hu>
Date: Tue, 23 Oct 2007 16:01:41 +0200
In-Reply-To: <20071023131009.GA32298@elte.hu> (Ingo Molnar's message of "Tue\, 23 Oct 2007 15\:10\:09 +0200")
Message-ID: <p73sl427wvu.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Andi Kleen <andi@firstfloor.org> wrote:
>
>> > so this patch adds back fastcall annotations. This serves as 
>> > documentation for assembly calling-convention dependencies as well.
>> 
>> You should rename it then to "asmcall" or something.
>
> if then that should be a separate renaming patch.

Well you're asking for the ugly hacks for out of tree code.  Any clean
ups needed should be your duty  (and it's still unclear why exactly
regparm should not work with -pg anyways -- before readding ugly
stuff perhaps that should be clarified too)

-Andi

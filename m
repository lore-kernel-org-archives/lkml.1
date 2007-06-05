Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbXFELdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbXFELdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 07:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbXFELdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 07:33:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36106 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbXFELdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 07:33:14 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Yoann Padioleau <padator@wanadoo.fr>
Subject: Re: [KJ] Re: [PATCH] bugfix GFP_KERNEL -> GFP_ATOMIC in spin_locked region
Date: Tue, 5 Jun 2007 13:33:11 +0200
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@lists.osdl.org
References: <87odjvu1on.fsf@wanadoo.fr> <20070604210018.0eaa20a0.akpm@linux-foundation.org> <87k5uimzkh.fsf@wanadoo.fr>
In-Reply-To: <87k5uimzkh.fsf@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706051333.12219.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 5. Juni 2007 13:05 schrieb Yoann Padioleau:
> Ok. Do you have a preference on the format ?  a <file>:<line> format  ?
> 
> Is there a place that gathered all those implicit programming rules 
> (that copy_from_user must not be called inside a spinlock, etc) so that
> I can translate them in a script for our tool.

How much C does your tool understand? You might basically
test for code paths that go to "might_sleep()"

	Regards
		Oliver

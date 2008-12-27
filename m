Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbYL0BCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbYL0BCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 20:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbYL0BCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 20:02:45 -0500
Received: from main.gmane.org ([80.91.229.2]:42515 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYL0BCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 20:02:44 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ben Pfaff <blp@cs.stanford.edu>
Subject: Re: SD/MMC cards: how crappy they are?
Date: Fri, 26 Dec 2008 17:03:36 -0800
Message-ID: <87hc4qpgyf.fsf@blp.benpfaff.org>
References: <20081202144830.GB1549@ucw.cz> <493562A5.40308@zytor.com> <20081202165608.GD18162@mit.edu> <20081226223908.GA2260@atrey.karlin.mff.cuni.cz>
Reply-To: blp@cs.stanford.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-75-36-169-231.dsl.pltn13.sbcglobal.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:ZxDZcIPcyR4qZPVnFBKGswvbMHU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@suse.cz> writes:

> @@ -211,6 +215,10 @@
>  bad blocks. Therefore it is recommended to use it only when one wants
>  to know if there are any bad blocks at all on the device, and not when
>  the list of bad blocks is wanted.
> +
> +You can send SIGALARM to make badblocks report its progress. You can
> +send SIGTERM to make badblocks terminate; it will catch the signal, clean
> +up and exit.

s/SIGALARM/SIGALRM/
-- 
Ben Pfaff 
http://benpfaff.org


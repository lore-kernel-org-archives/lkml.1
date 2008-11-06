Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbYKFJX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbYKFJX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 04:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYKFJXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 04:23:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:51797 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbYKFJXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 04:23:18 -0500
From: Andreas Schwab <schwab@suse.de>
To: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix msr check in compat_sys_swapcontext
References: <jeprlabbi6.fsf@sykes.suse.de>
	<18706.16317.759662.855430@cargo.ozlabs.ibm.com>
X-Yow: Hmmm...  an arrogant bouquet with a subtle suggestion of
 POLYVINYL CHLORIDE...
Date: Thu, 06 Nov 2008 10:23:16 +0100
In-Reply-To: <18706.16317.759662.855430@cargo.ozlabs.ibm.com> (Paul
	Mackerras's message of "Thu, 6 Nov 2008 11:52:13 +1100")
Message-ID: <jey6zx9piz.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras <paulus@samba.org> writes:

> we need to use get_user, not __get_user, since we haven't done an
> access_ok() check on the address.

The address is always ok since its a compat pointer, see do_setcontext.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

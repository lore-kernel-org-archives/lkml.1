Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbYCLSrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbYCLSrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYCLSrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:47:35 -0400
Received: from ns.suse.de ([195.135.220.2]:46306 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbYCLSrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:47:35 -0400
From: Andreas Schwab <schwab@suse.de>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] correct flags to f_mode conversion in __dentry_open
References: <1205346327.5297.232.camel@localhost.localdomain>
X-Yow: It was a JOKE!!  Get it??  I was receiving messages
 from DAVID LETTERMAN!!  YOW!!
Date: Wed, 12 Mar 2008 19:47:33 +0100
In-Reply-To: <1205346327.5297.232.camel@localhost.localdomain> (Eric Paris's
	message of "Wed\, 12 Mar 2008 14\:25\:27 -0400")
Message-ID: <je1w6fpynu.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> writes:

> Notice that 3 == (O_RDWR | O_WRONLY)

Note that O_RDWR and O_WRONLY are not simple flags, but two possible
values of a 2-bit field (O_ACCMODE).  Thus it does not makes sense to
add them together.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

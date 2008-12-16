Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbYLPJhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbYLPJhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 04:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbYLPJhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 04:37:01 -0500
Received: from ns2.suse.de ([195.135.220.15]:40594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbYLPJhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 04:37:00 -0500
From: Andreas Schwab <schwab@suse.de>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 1/1] hvc_console: escape magic sysrq key
References: <20081216091544.061115344@linux.vnet.ibm.com>
	<20081216092408.362722962@linux.vnet.ibm.com>
X-Yow: Kids, don't gross me off..  ``Adventures with MENTAL HYGIENE''
 can be carried too FAR!
Date: Tue, 16 Dec 2008 10:36:55 +0100
In-Reply-To: <20081216092408.362722962@linux.vnet.ibm.com> (Hendrik
	Brueckner's message of "Tue, 16 Dec 2008 10:15:45 +0100")
Message-ID: <jeiqpkcvgo.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hendrik Brueckner <brueckner@linux.vnet.ibm.com> writes:

> +					/* if ^0 is pressed again, reset
> +					 * sysrq_pressed and flip ^0 char */

The comment says ^0 twice when ^O is meant.

> +					sysrq_pressed = (sysrq_pressed) ? 0 : 1;

                                        sysrq_pressed = !sysrc_pressed;

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

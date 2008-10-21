Return-Path: <linux-kernel-owner+w=401wt.eu-S1752330AbYJUHo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbYJUHo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 03:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbYJUHou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 03:44:50 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:53378 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYJUHot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 03:44:49 -0400
Date: Tue, 21 Oct 2008 09:42:08 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC PATCH 0/5] patches for a network-based hvc backend (s390)
Message-ID: <20081021074208.GA8870@cetus.boeblingen.de.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Linux PPC devel <linuxppc-dev@ozlabs.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"Ryan S. Arnold" <rsa@us.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <20081014091247.433079967@linux.vnet.ibm.com> <1224545017.7654.188.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224545017.7654.188.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 10:23:37AM +1100, Benjamin Herrenschmidt wrote:
> What's the status with that patch serie ? Is this 2.6.28 material ?
It is 2.6.28 material.
> Alan, are you ok with those ? Hendrik, have there been any respin other
> than v2 of patch 4/5 ?
The other patches have not been changed.

fyi: patch 1/5 (hangup notifier) applies successfully with an offset
of 2 lines due to commit eef2622a9fcfa964073333ea72c7c9cd20ad45e6
(hvc_console: Fix free_irq in spinlocked section).


> I can merge it via powerpc but it's getting late in the merge window...
Thanks... that would be really great!

Regards
Hendrik

-- 
Hendrik Brueckner
D/3303 Linux on System z Development
Tel: +49 7031 16-1073
Fax: +49 7031 16-3456
eMail: brueckner@linux.vnet.ibm.com
IBM Deutschland Research & Development GmbH, Schoenaicher Str. 220, 71032 Boeblingen

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Geschaeftsfuehrung: Erich Baier
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294


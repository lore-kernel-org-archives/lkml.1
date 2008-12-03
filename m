Return-Path: <linux-kernel-owner+w=401wt.eu-S1752252AbYLCJRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbYLCJRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 04:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbYLCJR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 04:17:27 -0500
Received: from ozlabs.org ([203.10.76.45]:47047 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbYLCJR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 04:17:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18742.20121.759577.660481@cargo.ozlabs.ibm.com>
Date: Wed, 3 Dec 2008 20:17:13 +1100
From: Paul Mackerras <paulus@samba.org>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/1] hvc_console: fix: hp->ws winsize check runs out-of-sync
In-Reply-To: <20081118113848.945650506@linux.vnet.ibm.com>
References: <20081118112827.927627788@linux.vnet.ibm.com>
	<20081118113848.945650506@linux.vnet.ibm.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hendrik Brueckner writes:

> From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
> 
> The test to check for a new winsize runs out-of-sync with the underlying
> tty. After a tty has been released and initialized again, the winsize might
> differ between the tty and the hp struct. 
> The solution is to simply remove the check and always schedule the resize work.

Looks OK.  Is this going to go in via the s390 tree, or should I put
it in the powerpc tree?

Paul.

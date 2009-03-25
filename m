Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbZCYBOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbZCYBOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 21:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZCYBOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 21:14:12 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:34567 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbZCYBOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 21:14:11 -0400
Date: Tue, 24 Mar 2009 21:14:02 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Michael Riepe <michael.riepe@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Where did struct user_regs_struct{,32} go?
Message-ID: <20090325011402.GA15592@c2.user-mode-linux.org>
References: <49C96AFC.2030508@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C96AFC.2030508@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 12:21:32AM +0100, Michael Riepe wrote:
> Am I supposed to roll my own
> when I want to ptrace(PTRACE_GETREGS) the registers of a 32-bit process
> from 64-bit land?

Shouldn't the kernel convert the 32-bit registers into a 64-bit
user_regs_struct for GETREGS and convert them back for SETREGS?

				Jeff

-- 
Work email - jdike at linux dot intel dot com

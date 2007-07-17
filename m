Return-Path: <linux-kernel-owner+w=401wt.eu-S935124AbXGQQH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935124AbXGQQH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934802AbXGQQH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:07:26 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:38944 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934795AbXGQQHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:07:25 -0400
Date: Tue, 17 Jul 2007 12:07:10 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@qumranet.com>, KVM devel <kvm-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [PATCH 3/3] KVM - add hypercall nr to kvm_run
Message-ID: <20070717160710.GC7965@c2.user-mode-linux.org>
References: <20070716192447.GA16253@c2.user-mode-linux.org> <469C7C8D.1020600@qumranet.com> <469CCF17.3020709@codemonkey.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469CCF17.3020709@codemonkey.ws>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 09:15:51AM -0500, Anthony Liguori wrote:
> I'm planning on breaking this interface again since the new hypercall 
> API only takes 4 arguments instead of 6.

Is anything written anywhere about this hypercall interface?

The thing which would make me happy (which the current code comes
close to) is for the guest to be able to pass out Linux system calls
with VMCALL.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

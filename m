Return-Path: <linux-kernel-owner+w=401wt.eu-S1751163AbXBMHu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbXBMHu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 02:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbXBMHu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 02:50:56 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:24956
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163AbXBMHu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 02:50:56 -0500
Message-Id: <45D17C66.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Tue, 13 Feb 2007 07:52:54 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeff Dike" <jdike@addtoit.com>
Cc: "Andi Kleen" <ak@suse.de>, <linux-kernel@vger.kernel.org>,
       <patches@x86-64.org>
Subject: Re: [patches] [PATCH 2.6.21 review I] [4/25] x86: kernel-mode
	faults pollute current->thead
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Yup.  How does this patch look to you?  We set error_code and trap_no
>for userspace faults and kernel faults which call die().  We don't set
>them for kernelspace faults which are fixed up.

Actually, after a second round of thinking I believe there's still more to do
- your second patch missed fixing i386's do_trap() similarly to x86-64's
and, vice versa, x86-64's do_general_protection() similarly to i386's.

Jan

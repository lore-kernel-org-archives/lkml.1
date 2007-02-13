Return-Path: <linux-kernel-owner+w=401wt.eu-S1751227AbXBMKCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbXBMKCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 05:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbXBMKCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 05:02:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42796 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbXBMKCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 05:02:13 -0500
From: Andi Kleen <andi@firstfloor.org>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [patches] [PATCH 2.6.21 review I] [4/25] x86: kernel-mode faults pollute current->thead
Date: Tue, 13 Feb 2007 11:00:25 +0100
User-Agent: KMail/1.9.5
Cc: "Jeff Dike" <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
References: <45D17C66.76E4.0078.0@novell.com>
In-Reply-To: <45D17C66.76E4.0078.0@novell.com>
Organization: -
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131100.25829.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 February 2007 08:52, Jan Beulich wrote:
> >Yup.  How does this patch look to you?  We set error_code and trap_no
> >for userspace faults and kernel faults which call die().  We don't set
> >them for kernelspace faults which are fixed up.
> 
> Actually, after a second round of thinking I believe there's still more to do
> - your second patch missed fixing i386's do_trap() similarly to x86-64's
> and, vice versa, x86-64's do_general_protection() similarly to i386's.

I dropped the patch for now until that is all worked out

-Andi

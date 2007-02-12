Return-Path: <linux-kernel-owner+w=401wt.eu-S965024AbXBLRB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024AbXBLRB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 12:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965028AbXBLRB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 12:01:26 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:52435
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965024AbXBLRBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 12:01:24 -0500
Message-Id: <45D0AB68.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Mon, 12 Feb 2007 17:01:12 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeff Dike" <jdike@addtoit.com>
Cc: "Andi Kleen" <ak@suse.de>, <linux-kernel@vger.kernel.org>,
       <patches@x86-64.org>
Subject: Re: [patches] [PATCH 2.6.21 review I] [4/25] x86: kernel-mode
	faults pollute current->thead
References: <200702101250.142420000@suse.de>
 <20070210115016.652C913DCE@wotan.suse.de>
 <45D0422A.76E4.0078.0@novell.com>
 <20070212164247.GA5381@ccure.user-mode-linux.org>
In-Reply-To: <20070212164247.GA5381@ccure.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Yup.  How does this patch look to you?  We set error_code and trap_no
>for userspace faults and kernel faults which call die().  We don't set
>them for kernelspace faults which are fixed up.

That seems a reasonable approach.

Thanks, Jan

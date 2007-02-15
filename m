Return-Path: <linux-kernel-owner+w=401wt.eu-S964943AbXBOICj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964943AbXBOICj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 03:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964945AbXBOICi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 03:02:38 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:51671
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964943AbXBOICi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 03:02:38 -0500
Message-Id: <45D42160.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Thu, 15 Feb 2007 08:01:20 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeff Dike" <jdike@addtoit.com>
Cc: "Andi Kleen" <ak@suse.de>, <linux-kernel@vger.kernel.org>,
       <patches@x86-64.org>
Subject: Re: [patches] [PATCH 2.6.21 review I] [4/25] x86: kernel-mode
	faults pollute current->thead
References: <45D17C66.76E4.0078.0@novell.com>
 <20070214175114.GB5801@ccure.user-mode-linux.org>
In-Reply-To: <20070214175114.GB5801@ccure.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeff Dike <jdike@addtoit.com> 14.02.07 18:51 >>>
>On Tue, Feb 13, 2007 at 07:52:54AM +0000, Jan Beulich wrote:
>> Actually, after a second round of thinking I believe there's still more to do
>> - your second patch missed fixing i386's do_trap() similarly to x86-64's
>> and, vice versa, x86-64's do_general_protection() similarly to i386's.
>
>Sigh, here's another go at it - the full patch instead of
>incrementally fixing the old one:

Ack.

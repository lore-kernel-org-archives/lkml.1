Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbYKTPto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbYKTPto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYKTPtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:49:35 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:15046 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYKTPte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:49:34 -0500
Message-Id: <49259561.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 20 Nov 2008 15:50:41 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Glauber Costa" <gcosta@redhat.com>, "Matt Mackall" <mpm@selenic.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: clean up after: move entry_64.S register
	 savingout of the macros
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm>
 <20081117175232.GA13766@mailshack.com>
 <20081119001811.GA23237@mailshack.com>
 <20081120134011.GA3627@mailshack.com> <20081120150412.GC13550@elte.hu>
 <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu>
In-Reply-To: <20081120153954.GA22511@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 20.11.08 16:39 >>>
>movq_cfi for the frame construction direction and movq_cfi_restore for 
>the frame deconstruction phase sounds like a good naming compromise, hm?

How about movq_spill and movq_fill (losely following some ia64 terminology)?

Jan


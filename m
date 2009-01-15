Return-Path: <linux-kernel-owner+w=401wt.eu-S1762272AbZAOIw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272AbZAOIw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 03:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbZAOIwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 03:52:50 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:42364 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207AbZAOIwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 03:52:49 -0500
Message-Id: <496F0796.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 15 Jan 2009 08:53:26 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: simplify HIGHMEM-related Kconfig entries
References: <496DE927.76E4.0078.0@novell.com> <496E3F7D.2060908@zytor.com>
In-Reply-To: <496E3F7D.2060908@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H. Peter Anvin" <hpa@zytor.com> 14.01.09 20:39 >>>
>Jan Beulich wrote:
>> Additionally remove the dependency of X86_PAE on !HIGHMEM4G - at least
>> I can't understand why that dependency existed.
>
>At least originally, the meaning of the x86 highmem entries were:
>
>	No highmem	- No highmem, no PAE
>	HIGHMEM4G	- Highmem, no PAE
>	HIGHMEM64G	- Highmem, PAE
>
>So X86_PAE and HIGHMEM4G is a bit of a contradiction.  I haven't looked 
>at the logic in detail, or remember offhand if there have been any 
>weakening of the definitions above; e.g. someone could have implemented 
>a way to do PAE without highmem, to get access to the NX bits.

Exactly - .23 made PAE an independently selectable option (in particular,
the no-highmem+PAE combination is now valid), but I can't see why it
added the !HIGHMEM4G dependency.

Jan


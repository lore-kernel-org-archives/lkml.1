Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbZANTjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbZANTjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756589AbZANTjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:39:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39210 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbZANTjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:39:23 -0500
Message-ID: <496E3F7D.2060908@zytor.com>
Date: Wed, 14 Jan 2009 11:39:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: simplify HIGHMEM-related Kconfig entries
References: <496DE927.76E4.0078.0@novell.com>
In-Reply-To: <496DE927.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Additionally remove the dependency of X86_PAE on !HIGHMEM4G - at least
> I can't understand why that dependency existed.

At least originally, the meaning of the x86 highmem entries were:

	No highmem	- No highmem, no PAE
	HIGHMEM4G	- Highmem, no PAE
	HIGHMEM64G	- Highmem, PAE

So X86_PAE and HIGHMEM4G is a bit of a contradiction.  I haven't looked 
at the logic in detail, or remember offhand if there have been any 
weakening of the definitions above; e.g. someone could have implemented 
a way to do PAE without highmem, to get access to the NX bits.

	-hpa

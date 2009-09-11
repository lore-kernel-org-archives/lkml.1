Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbZIKBfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbZIKBfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 21:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZIKBfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 21:35:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49621 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbZIKBfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 21:35:04 -0400
Message-ID: <4AA9A8F6.50709@zytor.com>
Date: Thu, 10 Sep 2009 18:33:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Daney <ddaney@caviumnetworks.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 02/10] x86: Convert BUG() to use unreachable()
References: <4AA991C1.1050800@caviumnetworks.com> <1252627011-2933-2-git-send-email-ddaney@caviumnetworks.com> <4AA9A031.5000602@zytor.com> <alpine.LFD.2.01.0909101806110.3654@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0909101806110.3654@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2009 06:13 PM, Linus Torvalds wrote:
> 
> I realize that the RH backport thing is good for testing now, but at the 
> same time, it really does look nasty. I wonder if we could add some 
> config-time compiler feature testing - so that you'd not have a version 
> test at all, but a CONFIG_BUILTIN_UNREACHABLE.
> 

autoconf ;)

	-hpa

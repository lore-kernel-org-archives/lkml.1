Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbYGRVey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbYGRVey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 17:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbYGRVer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 17:34:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57925 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbYGRVeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 17:34:46 -0400
Message-ID: <48810C62.2000108@zytor.com>
Date: Fri, 18 Jul 2008 14:34:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix two modpost warnings
References: <4880AAC1.76E4.0078.0@novell.com>
In-Reply-To: <4880AAC1.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Even though it's only the difference of the two __initdata symbols
> that's being calculated, modpost still doesn't like this. So rather
> calculate the size once in an __init function and store it for later
> use.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Applied to x86/cleanups, thanks!

	-hpa

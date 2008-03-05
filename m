Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbYCESWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbYCESWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 13:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbYCESV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 13:21:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47149 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365AbYCESV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 13:21:58 -0500
Message-ID: <47CEE3C1.8060304@zytor.com>
Date: Wed, 05 Mar 2008 10:17:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Aurelien Jarno <aurelien@aurel32.net>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Clear DF before calling signal handler
References: <20080305153020.GA24631@volta.aurel32.net> <20080305181424.GA12678@hall.aurel32.net>
In-Reply-To: <20080305181424.GA12678@hall.aurel32.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aurelien Jarno wrote:
> The Linux kernel currently does not clear the direction flag before
> calling a signal handler, whereas the x86/x86-64 ABI requires that.
> This become a real problem with gcc version 4.3, which assumes that
> the direction flag is correctly cleared at the entry of a function.
> 
> This patches changes the setup_frame() functions to clear the
> direction before entering the signal handler.
> 
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>

Acked-by: H. Peter Anvin <hpa@zytor.com>


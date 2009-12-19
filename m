Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZLSA03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZLSA03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 19:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbZLSA0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 19:26:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38882 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933AbZLSA0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 19:26:15 -0500
Message-ID: <4B2C1D69.8090703@zytor.com>
Date: Fri, 18 Dec 2009 16:25:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] x86: move range related operation to one file
References: <4B2B4C19.6010402@kernel.org> <4B2B4F85.5030901@kernel.org> <4B2BE1BF.60803@zytor.com> <4B2BE348.207@kernel.org> <4B2BF38F.3090101@zytor.com> <4B2C14A3.90906@kernel.org>
In-Reply-To: <4B2C14A3.90906@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2009 03:47 PM, Yinghai Lu wrote:
> 
> i could try to merge range handling to to early_res handling code.
> first step is change the end in range to be consistent to the one in early_res.
> 
> later could move them into kernel/range.c or kernel/early_res.c after we convert all bootmem to early_res.
> 

Seems reasonable, I guess.

	-hpa


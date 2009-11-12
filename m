Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbZKLF0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbZKLF0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 00:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZKLF0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 00:26:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37976 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbZKLF0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 00:26:46 -0500
Message-ID: <4AFB9C8D.9000800@zytor.com>
Date: Wed, 11 Nov 2009 21:26:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Ma, Ling" <ling.ma@intel.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast 	string.
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com>	 <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com>	 <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>	 <4AF7C66C.6000009@zytor.com> <20091109080830.GI453@elte.hu>	 <8FED46E8A9CA574792FC7AACAC38FE7714FE830398@PDSMSX501.ccr.corp.intel.com>	 <20091111203425.GA25401@lenovo> <4AFB3D31.6070901@zytor.com> <aa79d98a0911112028nf3fc475r30aa8dc37936ea22@mail.gmail.com> <8FED46E8A9CA574792FC7AACAC38FE7714FE8307DB@PDSMSX501.ccr.corp.intel.com>
In-Reply-To: <8FED46E8A9CA574792FC7AACAC38FE7714FE8307DB@PDSMSX501.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 08:49 PM, Ma, Ling wrote:
> Hi All
> The attachment is latest memcpy.c, please update by 
> "cc -o memcpy memcpy.c -O2 -m64".

OK... given that there seems to be no point since the actual code we're
talking about modifying doesn't ever actually get executed on the real
kernel, we can just drop this, right?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


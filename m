Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZKJRQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZKJRQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbZKJRQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:16:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54355 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220AbZKJRQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:16:40 -0500
Message-ID: <4AF99F0C.2050806@zytor.com>
Date: Tue, 10 Nov 2009 09:12:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Jan Beulich <jbeulich@novell.com>, Vegard Nossum <vegardno@ifi.uio.no>,
       Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] [x86] detect and report lack of NX protections
References: <4ADD1E03.4070200@zytor.com> <20091020045513.GU5394@outflux.net> <20091109221015.GB5129@outflux.net> <4AF8A2C0.5080700@zytor.com> <20091110154956.GF5129@outflux.net> <4AF9991B.20400@zytor.com> <20091110165738.GH5129@outflux.net>
In-Reply-To: <20091110165738.GH5129@outflux.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 08:57 AM, Kees Cook wrote:
> 
> 64-bit does not set nx_enabled to "1" by default anywhere.  And setting
> the default to 1 in check_efer() seemed out of place to me.
> 

If it doesn't set nx_enabled anywhere, you'll end up with the message

+	printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
+	       "missing in CPU or disabled in BIOS!\n");

which seems obviously wrong... no?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbZCZWM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbZCZWM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbZCZWMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:12:19 -0400
Received: from ozlabs.org ([203.10.76.45]:51524 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456AbZCZWMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:12:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH -tip] x86: unification of module.c
Date: Fri, 27 Mar 2009 08:42:09 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
References: <1238072913.2507.3.camel@ht.satnam>
In-Reply-To: <1238072913.2507.3.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903270842.10039.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 March 2009 23:38:33 Jaswinder Singh Rajput wrote:
> Impact: Unification, cleanup
...
> +#if (defined(CONFIG_X86_32) || !defined(CONFIG_UML))
> +
> +#ifdef CONFIG_X86_64

This looks wrong...
Rusty.

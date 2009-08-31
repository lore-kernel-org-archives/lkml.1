Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbZHaGWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbZHaGWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 02:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbZHaGWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 02:22:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:39094 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166AbZHaGWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 02:22:02 -0400
Message-ID: <4A9B6BF6.1030000@kernel.org>
Date: Mon, 31 Aug 2009 15:21:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Michal Schmidt <mschmidt@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: detect stack protector for i386 builds on x86_64
References: <20090829182718.10f566b1@leela>
In-Reply-To: <20090829182718.10f566b1@leela>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 06:21:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Schmidt wrote:
> Stack protector support was not detected when building with ARCH=i386
> on x86_64 systems:
> arch/x86/Makefile:80: stack protector enabled but no compiler support
> 
> The "-m32" argument needs to be passed to the detection script.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

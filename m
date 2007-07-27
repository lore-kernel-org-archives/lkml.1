Return-Path: <linux-kernel-owner+w=401wt.eu-S937977AbXG0U5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937977AbXG0U5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937513AbXG0U4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:56:11 -0400
Received: from gw.goop.org ([64.81.55.164]:33837 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936239AbXG0U4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:56:01 -0400
Message-ID: <46AA5B7B.7040406@goop.org>
Date: Fri, 27 Jul 2007 13:54:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       martin.pitt@ubuntu.com, wwoods@redhat.com
Subject: Re: [PATCH 2/3] core_pattern: allow passing of arguments to user
 mode helper when core_pattern is a pipe
References: <20070727200746.GC18946@hmsreliant.homelinux.net>
In-Reply-To: <20070727200746.GC18946@hmsreliant.homelinux.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> +	int helper_argc = 0;
>   
> +		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
>   

Hm, I suspect most users of argv_split don't really care about argc, so
it would useful to change argv_split to take NULL as the argc pointer,
rather than declare a bunch of unused variables.  Interested in throwing
a patch together?

    J

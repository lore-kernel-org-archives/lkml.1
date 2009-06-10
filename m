Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbZFJGka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbZFJGka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 02:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbZFJGkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 02:40:22 -0400
Received: from ozlabs.org ([203.10.76.45]:60187 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbZFJGkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 02:40:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: rr tree build warning
Date: Wed, 10 Jun 2009 16:10:17 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090609162636.d2351007.sfr@canb.auug.org.au>
In-Reply-To: <20090609162636.d2351007.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906101610.20265.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 03:56:36 pm Stephen Rothwell wrote:
> Hi Rusty,
>
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
>
> arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1287: warning: passing argument 1
> of 'check_supported_cpu' makes pointer from integer without a cast
> arch/x86/kernel/cpu/cpufreq/powernow-k8.c:514: note: expected 'void *' but
> argument is of type 'unsigned int'
>
> Introduced by commit b3594a9ce5fb32533084ec75f1954c93f461591d ("cpumask:
> avoid playing with cpus_allowed in powernow-k8.c").

Thanks, I've revisited this patch and fixed this too.

Thanks,
Rusty.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbXISWd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbXISWd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbXISWdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:33:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48187 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853AbXISWds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:33:48 -0400
Date: Wed, 19 Sep 2007 15:33:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, discuss@x86-64.org
Subject: Re: [patch 3/7] Use extended crashkernel command line on x86_64
Message-Id: <20070919153329.cfe714e3.akpm@linux-foundation.org>
In-Reply-To: <20070913161429.387888398@strauss.suse.de>
References: <20070913161428.343951643@strauss.suse.de>
	<20070913161429.387888398@strauss.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 18:14:31 +0200
Bernhard Walle <bwalle@suse.de> wrote:

> +#ifdef CONFIG_KEXEC
> +static inline void reserve_crashkernel(void)
> +{

The x86_64 function was made inline, so it will actually end up in
.text.init.  But the i386 equivalent function was not inlined so I'm not
sure whether it will end up in .text or in .text.init.

Could you fix all that up please?

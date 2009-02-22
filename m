Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZBVQYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZBVQYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 11:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZBVQYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 11:24:04 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:63130 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbZBVQYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 11:24:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jA+noeC8z0KV2n/5+CKAJf5xBEuemXzf1RFMcCy9zyIYOCI76RN1nyGYjD9otP/AYo
         iEro7H4BgMie3BM8vBciG5EbASQx0d9eor8oKFtUpmyHF2ICJSUKD3Zdk2ti7PGtnpiE
         24A2OhCqsRZdadTc91WGkaZItFeCOrSXwjCdQ=
Date: Sun, 22 Feb 2009 17:23:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, markus.t.metzger@gmail.com
Subject: Re: [PATCH -mm] tracing: Fix section mismatch in
	trace_hw_branches.c
Message-ID: <20090222162355.GB6003@nowhere>
References: <b9df5fa10902131936p5e0997c6p57f659457a9cc356@mail.gmail.com> <20090221152251.GA6807@nowhere> <20090223010906.BD48.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223010906.BD48.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 01:15:08AM +0900, KOSAKI Motohiro wrote:
> > When I saw this patch, I searched the real purpose of __cpuinit and its
> > real impact.
> > But I didn't find any comments about it inside the kernel.
> 
> AFAIK, __cpuinit mean
> 
> if UP,                     __cpuinit == __init
> if SMP=Y && HOTPLUG_CPU=y, __cpuinit == "" (do nothing)
> if SMP=Y && HOTPLUG_CPU=n, __cpuinit == __init
> 
> 
>

Ok, thanks for the information. 


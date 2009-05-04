Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZEDTKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZEDTKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZEDTJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:09:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbZEDTJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:09:56 -0400
Date: Mon, 4 May 2009 12:00:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jake Edge <jake@lwn.net>
cc: security@kernel.org, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Roland McGrath <roland@redhat.com>,
       mingo@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged
 processes
In-Reply-To: <20090504125114.5e391564@chukar>
Message-ID: <alpine.LFD.2.01.0905041159480.4983@localhost.localdomain>
References: <20090504125114.5e391564@chukar>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 4 May 2009, Jake Edge wrote:
>
> This is essentially v2 of "[PATCH] proc: avoid leaking eip, esp, or
> wchan to non-privileged processes", adding some of Eric Biederman's
> suggestions as well as the start_stack change (only give out that
> address if the process is ptrace()-able).  This has been tested with ps
> and top without any ill effects being seen.

Looks sane to me. Anybody objects?

		Linus

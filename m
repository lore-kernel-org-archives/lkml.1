Return-Path: <linux-kernel-owner+w=401wt.eu-S1762801AbZE3RWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762801AbZE3RWJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 13:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760273AbZE3RWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 13:22:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147AbZE3RWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 13:22:04 -0400
Date: Sat, 30 May 2009 10:21:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Larry H." <research@subreption.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu, faith@redhat.com
Subject: Re: [patch 3/5] Apply the PG_sensitive flag to audit subsystem
In-Reply-To: <20090520185005.GC10756@oblivion.subreption.com>
Message-ID: <alpine.LFD.2.01.0905301020260.3435@localhost.localdomain>
References: <20090520185005.GC10756@oblivion.subreption.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 May 2009, Larry H. wrote:
>
> +	if (!(gfp_mask & GFP_SENSITIVE))
> +		gfp_mask |= GFP_SENSITIVE;

WTF?

Why is this different from just "gfp_mask |= GFP_SENSITIVE;"

		Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZEaCCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZEaCCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 22:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZEaCCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 22:02:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752AbZEaCCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 22:02:40 -0400
Date: Sat, 30 May 2009 19:02:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Larry H." <research@subreption.com>
cc: linux-mm@kvack.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Change ZERO_SIZE_PTR to point at unmapped space
In-Reply-To: <20090530230022.GO6535@oblivion.subreption.com>
Message-ID: <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain>
References: <20090530192829.GK6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301528540.3435@localhost.localdomain> <20090530230022.GO6535@oblivion.subreption.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 May 2009, Larry H. wrote:
> 
> Like I said in the reply to Peter, this is 3 extra bytes for amd64 with
> gcc 4.3.3. I can't be bothered to check other architectures at the
> moment.

.. and I can't be bothered with applying this. I'm just not convinced.

It's 3 extra bytes just for the constant. It's also another test, and 
another branch.

		Linus

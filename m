Return-Path: <linux-kernel-owner+w=401wt.eu-S1763866AbYEIBgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763866AbYEIBgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 21:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbYEIBgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 21:36:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316AbYEIBgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 21:36:19 -0400
Date: Thu, 8 May 2008 18:36:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
cc: kernel list <linux-kernel@vger.kernel.org>,
       Gary Hade <garyhade@us.ibm.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: regression fixed by using pci=rom
In-Reply-To: <21d7e9970805081654h6de38d58q5ad3b6d3520b45f1@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0805081834490.2940@woody.linux-foundation.org>
References: <21d7e9970805081654h6de38d58q5ad3b6d3520b45f1@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 May 2008, Dave Airlie wrote:
>
> A user just reported this bug
> 
> http://bugs.freedesktop.org/show_bug.cgi?id=15523
> 
> He says using pci=rom fixes the regression, do we truly have to start
> booting machines with this, sucks to be a distro..

Yeah, that commit he bisected to is bogus crap.

I'll revert it.

		Linus

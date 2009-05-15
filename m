Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbZEOBtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbZEOBtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 21:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbZEOBtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 21:49:31 -0400
Received: from tundra.namei.org ([65.99.196.166]:42929 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbZEOBtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 21:49:31 -0400
Date: Fri, 15 May 2009 11:49:29 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v2)
In-Reply-To: <200905142108.JIF10080.OOFHJVFtOSQMFL@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LRH.2.00.0905151146320.5937@tundra.namei.org>
References: <20090501102438.GA7470@elf.ucw.cz> <200905012207.BFC60616.QStOHOMJFOLFFV@I-love.SAKURA.ne.jp> <20090503215615.GA1368@ucw.cz> <200905041524.GGH52160.FFFVMSJOOLtHOQ@I-love.SAKURA.ne.jp> <200905062116.HCI09807.VOFFHFSMOLOtQJ@I-love.SAKURA.ne.jp>
 <200905142108.JIF10080.OOFHJVFtOSQMFL@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Tetsuo Handa wrote:

> ---
>  security/tomoyo/common.c   |  456 +++++++++++++++++++-----------------
>  security/tomoyo/common.h   |  134 ++++++++--
>  security/tomoyo/domain.c   |  437 +++++++++++++---------------------
>  security/tomoyo/file.c     |  369 +++++++++++++++--------------
>  security/tomoyo/realpath.c |  567 ++++++++++++++++++++++++++++++++++-----------
>  security/tomoyo/realpath.h |   25 +
>  security/tomoyo/tomoyo.c   |   40 +--
>  security/tomoyo/tomoyo.h   |   13 -
>  8 files changed, 1190 insertions(+), 851 deletions(-)

This seems like an awfully large and invasive patch just to add GC support 
which you didn't originally didn't think was necessary.

I think it needs review from people outside of your project.


- James
-- 
James Morris
<jmorris@namei.org>

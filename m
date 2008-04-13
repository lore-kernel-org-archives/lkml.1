Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbYDMVQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbYDMVQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 17:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYDMVQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 17:16:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35888 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbYDMVQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 17:16:08 -0400
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
From: David Woodhouse <dwmw2@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, akpm@linux-foundation.org, me@bobcopeland.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
	 <20080412170304.54f139e2.akpm@linux-foundation.org>
	 <20080413033344.GA27494@hash.localnet>
	 <20080412205544.5e12a7d4.akpm@linux-foundation.org>
	 <20080413080130.GA9622@infradead.org>
	 <20080413012001.8d7967f4.akpm@linux-foundation.org>
	 <20080413082815.GA20108@infradead.org>
	 <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Sun, 13 Apr 2008 22:15:58 +0100
Message-Id: <1208121358.2700.4.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-13 at 12:37 +0200, Miklos Szeredi wrote:
> There's one thing which makes fuse a slightly better candidate for
> applications where the number of users is low: stability.  Unless you
> or your users test the hell out of your filesystem, there always a
> chance that some bugs will remain.  These rarely bring down the whole
> system, but it usually requires a reboot to let you continue using the
> Oopsing fs.

I think it's a slippery slope from that to rewriting Linux as a
microkernel.

Simple block filesystems like this belong in the kernel.

-- 
dwmw2


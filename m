Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYEYOgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYEYOgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 10:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYEYOgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 10:36:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37175 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbYEYOgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 10:36:37 -0400
Subject: Re: [PATCHv2 04/28] cx25840: treat firmware data as const
From: David Woodhouse <dwmw2@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, Tyler Trafford <ttrafford@gmail.com>,
       Mike Isely <isely@isely.net>
In-Reply-To: <200805251251.32373.hverkuil@xs4all.nl>
References: <1211708969@pmac.infradead.org>
	 <E1K0DO1-0007D2-3d@shinybook.infradead.org>
	 <200805251251.32373.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sun, 25 May 2008 15:36:31 +0100
Message-Id: <1211726191.31212.112.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-25 at 12:51 +0200, Hans Verkuil wrote:
> There is no need to do the first two bytes first. As far as I can tell 
> it was done to avoid having to allocate a local buffer. 

Thanks. I suspected as much, but wanted to err on the side of caution
since I can't test it. I'll change it in the next iteration.

-- 
dwmw2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759932AbYCZNT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932AbYCZNT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 09:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbYCZNTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 09:19:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59235 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYCZNTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 09:19:47 -0400
Subject: Re: why so many unexported headers checking __KERNEL__?
From: David Woodhouse <dwmw2@infradead.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.00.0803260913350.6316@localhost.localdomain>
References: <alpine.LFD.1.00.0803230229530.1203@localhost.localdomain>
	 <1206533324.9540.268.camel@pmac.infradead.org>
	 <alpine.LFD.1.00.0803260846390.6148@localhost.localdomain>
	 <1206537022.9540.274.camel@pmac.infradead.org>
	 <alpine.LFD.1.00.0803260913350.6316@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 13:19:46 +0000
Message-Id: <1206537586.9540.280.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-26 at 09:16 -0400, Robert P. J. Day wrote:
> well, since i already have the output from my script, i might toss
> together some per-directory patches to start removing some of that.
> this sounds more like a one-shot thing than adding permanent checking
> to the build process.

Makes sense.

Remember, one of our goals is to move towards having files which are
just _copied_ (header-y) instead of having these ifdefs. If, in your
travels, you see a way you can split headers up more sensibly to achieve
that, it would be good.

-- 
dwmw2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbYLBQym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbYLBQym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 11:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYLBQye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 11:54:34 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:51130 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbYLBQye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 11:54:34 -0500
Date: Tue, 2 Dec 2008 17:55:57 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: About git-bisect (was: Linux 2.6.28-rc7)
Message-ID: <20081202165557.GA10637@uranus.ravnborg.org>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org> <20081202131442.42e7df48@varda> <alpine.LFD.2.00.0812020748310.3256@nehalem.linux-foundation.org> <20081202165637.09984819@varda> <alpine.LFD.2.00.0812020804590.3256@nehalem.linux-foundation.org> <49356274.6080400@diamondcut.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49356274.6080400@diamondcut.com.br>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I need more than 20min to compile each kernel, so is necessary ~260min.

You do not need to do a "make clean" between each build, so if none
of the core files are touched you should be much faster.
Do you bisect and then type make should be enough.

	Sam

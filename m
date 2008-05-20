Return-Path: <linux-kernel-owner+w=401wt.eu-S934975AbYETP7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934975AbYETP7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763837AbYETP6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:58:46 -0400
Received: from vena.lwn.net ([206.168.112.25]:34642 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086AbYETP6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:58:45 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Tue, 20 May 2008 17:28:43 +0200."
             <20080520152843.CF4181B4205@basil.firstfloor.org> 
Date: Tue, 20 May 2008 09:58:45 -0600
Message-ID: <27468.1211299125@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess my one concern with this mirrors what other people have said:
might not it be better to just push the BKL down into the fasync()
implementations and avoid adding yet another file operation?  A quick
grep shows 43 drivers defining fasync() functions - and many of those
use the same one.  fs/ has a few more.  Obnoxious but doable, unless
there's something I'm missing?

Thanks,

jon

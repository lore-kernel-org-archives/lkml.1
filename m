Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYHHBDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYHHBDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYHHBDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:03:08 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:48700
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYHHBDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:03:07 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] fix extern inline errors with gcc 4.3.0
Date: Thu, 7 Aug 2008 20:02:56 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jeff Dike <jdike@addtoit.com>, Benny Halevy <bhalevy@panasas.com>,
       linux-kernel@vger.kernel.org
References: <1214488251-20927-1-git-send-email-bhalevy@panasas.com> <48673A9B.8050907@panasas.com> <20080630162201.GC6643@c2.user-mode-linux.org>
In-Reply-To: <20080630162201.GC6643@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808072002.57539.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 June 2008 11:22:01 Jeff Dike wrote:
> 	Uli reported a crash on x86_64 with gcc 4.1.2 with unit-at-a-time
...
> If that crash does come back, I'd say we should just debug it.  It's
> likely UML implicitly relying on some gcc behavior anyway.

Well, I'm seeing the crash in stock 2.6.26.  For the moment I'm reverting

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4f81c5350b44bcc501ab6f8a089b16d064b4d2f6

And then it runs fine.  (With gcc 4.1.2, on x86-64.)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbYD1HhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbYD1HhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763172AbYD1Hgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:36:54 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34989 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820AbYD1Hgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:36:53 -0400
Date: Mon, 28 Apr 2008 09:36:52 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: current git: spinlock lockup while starting init
Message-ID: <20080428073652.GA6064@Chamillionaire.breakpoint.cc>
References: <20080426175351.GA19032@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080426175351.GA19032@Chamillionaire.breakpoint.cc>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Siewior | 2008-04-26 19:53:51 [+0200]:

>|commit 3b1253880b7a9e6db54b943b2d40bcf2202f58ab
issue gone with 50704516f3
"Fix uninitialized 'copy' in unshare_files", thx Al Viro

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbXEAOtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbXEAOtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXEAOtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:49:25 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:53145 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbXEAOtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:49:23 -0400
Date: Tue, 1 May 2007 08:49:57 -0600
From: dann frazier <dannf@debian.org>
To: Andres Salomon <dilinger@debian.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, support@moxa.com.tw
Subject: Re: old buffer overflow in moxa driver
Message-ID: <20070501144957.GB22774@krebs.dannf>
References: <20070430224829.GI31283@krebs.dannf> <20070501000455.2173b1e2@the-village.bc.nu> <4636F337.3060702@gmail.com> <4636FA67.70407@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4636FA67.70407@debian.org>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 04:29:27AM -0400, Andres Salomon wrote:
> Right; the lack of input checking is most definitely a bug.  It's no
> longer a security issue, as a CAP_SYS_RAWIO check was added at some
> point to the code path, but it's still a bug.

I hadn't noticed this, but yes - the CAP_SYS_RAWIO check was added in
2.6.16.

-- 
dann frazier | HP Open Source and Linux Organization

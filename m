Return-Path: <linux-kernel-owner+w=401wt.eu-S1751467AbXB0I5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbXB0I5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161052AbXB0I5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:57:49 -0500
Received: from mx2.go2.pl ([193.17.41.42]:43902 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751467AbXB0I5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:57:48 -0500
Date: Tue, 27 Feb 2007 10:01:27 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG][2.6.21] af_key: kernel BUG at net/core/skbuff.c:93
Message-ID: <20070227090127.GA1625@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226220841.GA7727@dreamland.darkstar.lan>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26-02-2007 23:08, Luca Tettamanti wrote:
> Hello,
> I'm running 2.6.21 (current git, at 9654640d0af). kernel blows up at
> startup, when running setkey. Kernel 2.6.20 runs fine. A couple of words
...
> ------------[ cut here ]------------
> kernel BUG at /home/kronos/src/linux-2.6.git/net/core/skbuff.c:93!
> invalid opcode: 0000 [#1]

Hi!

Could you repeat this with: CONFIG_4KSTACKS=n ?

Regards,
Jarek P.

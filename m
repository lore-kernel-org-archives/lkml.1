Return-Path: <linux-kernel-owner+w=401wt.eu-S1751202AbXB0Qe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbXB0Qe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 11:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbXB0Qe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 11:34:27 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:37694 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbXB0Qe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 11:34:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fjfkOhq7Om6kQGWXHq/84HLFv5okM16W7uyh4i5Yno8xW5B6jaiPcWd4oXTDGpfCBk9H15or0G3qCkkR1NCYCLySvJ4REul7xlGfu1EZiUZbPR/biXiXPA9nb1G3E+gh/prUHou7Q6CGvt8kTcfREd1nW6kRLsX3/U2iAovzRcE=
Message-ID: <68676e00702270834j17bf7e4bgd50b6e271404927f@mail.gmail.com>
Date: Tue, 27 Feb 2007 17:34:21 +0100
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Jarek Poplawski" <jarkao2@o2.pl>
Subject: Re: [BUG][2.6.21] af_key: kernel BUG at net/core/skbuff.c:93
Cc: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070227090127.GA1625@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070226220841.GA7727@dreamland.darkstar.lan>
	 <20070227090127.GA1625@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/07, Jarek Poplawski <jarkao2@o2.pl> wrote:
> On 26-02-2007 23:08, Luca Tettamanti wrote:
> > Hello,
> > I'm running 2.6.21 (current git, at 9654640d0af). kernel blows up at
> > startup, when running setkey. Kernel 2.6.20 runs fine. A couple of words
> ...
> > ------------[ cut here ]------------
> > kernel BUG at /home/kronos/src/linux-2.6.git/net/core/skbuff.c:93!
> > invalid opcode: 0000 [#1]
>
> Hi!
>
> Could you repeat this with: CONFIG_4KSTACKS=n ?

Actually I cannot repeat after a make clean, with either stack
configurations. The original kernel still consistently dies in the
same point though. Must have been a mis-compilation :(
Sorry for the noise.

Luca

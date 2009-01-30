Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZA3VVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZA3VVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 16:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbZA3VVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 16:21:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50226 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486AbZA3VV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 16:21:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: WOL with forcedeth broken since f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
Date: Fri, 30 Jan 2009 22:20:59 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>
References: <20090129063118.GA3586@pmhahn.de> <86802c440901292253ie9e2a9dmb4580a3da1480c81@mail.gmail.com> <86802c440901300035i6d63b8b7nc8c401c3f8b945cb@mail.gmail.com>
In-Reply-To: <86802c440901300035i6d63b8b7nc8c401c3f8b945cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901302221.00559.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009, Yinghai Lu wrote:
> On Thu, Jan 29, 2009 at 10:53 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > On Wed, Jan 28, 2009 at 10:31 PM, Philipp Matthias Hahn
> > <pmhahn@titan.lahn.de> wrote:
> >> Hello!
> >>
> >> Somewhere between 2.6.26 and 2.6.27 WOL stopped working on my MS-7350
> >> motherboard with an "nVidia Corporation MCP51 Ethernet Controller (rev a3)".
> >>        "etherwake 00:19:db:f2:e1:35" did not work
> >>        "etherwake 35:e1:f2:db:19:00" did work
> 
> looks like your BIOS, already reverse the MAC addr...
> 
> please check attached ... Rafael, wonder if will break suspend/resume...

Well, it doesn't look like it's going to, but testing is necessary.

Thanks,
Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZBIH3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZBIH3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 02:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbZBIH2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 02:28:52 -0500
Received: from serv04.lahn.de ([213.239.197.57]:44770 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbZBIH2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 02:28:51 -0500
Date: Mon, 9 Feb 2009 08:28:47 +0100
From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ayaz Abdulla <aabdulla@nvidia.com>,
       Jeff Garzik <jeff@garzik.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: WOL with forcedeth broken since
	f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
Message-ID: <20090209072847.GA3467@pmhahn.de>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Yinghai Lu <yhlu.kernel@gmail.com>,
	Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <20090129063118.GA3586@pmhahn.de> <20090208151813.GA6941@yamamaya.is-a-geek.org> <20090208165217.GA3003@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090208165217.GA3003@yamamaya.is-a-geek.org>
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Sun, Feb 08, 2009 at 05:52:17PM +0100, Tobias Diedrich wrote:
> Tobias Diedrich wrote:
> > Philipp Matthias Hahn wrote:
> > > Somewhere between 2.6.26 and 2.6.27 WOL stopped working on my MS-7350
> > > motherboard with an "nVidia Corporation MCP51 Ethernet Controller (rev a3)".
> > > 	"etherwake 00:19:db:f2:e1:35" did not work
> > > 	"etherwake 35:e1:f2:db:19:00" did work
...
> With the following patch:
> shutdown         OK
> disk/shutdown    OK
> disk/platform    OK
> kexec            OK

Your patch seems to work for my system, too. (Expect for the case where
I do "poweroff" from busybox or do Alt-SysRq-O; Debians version works,
as long as I remove the '-i' option:
	-i     Shut down all network interfaces just before halt or reboot.

> Signed-off-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Tested-by: Philipp Matthias Hahn <pmhahn@titan.lahn.de>

BYtE
Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de

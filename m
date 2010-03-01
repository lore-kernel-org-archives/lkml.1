Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060Ab0CAJaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:30:12 -0500
Received: from melkor.forwiss.uni-passau.de ([132.231.20.39]:58215 "EHLO
	melkor.forwiss.uni-passau.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705Ab0CAJaB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:30:01 -0500
X-Greylist: delayed 1366 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2010 04:30:00 EST
Date: Mon, 1 Mar 2010 10:07:08 +0100
From: M G Berberich <berberic@fmi.uni-passau.de>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: 2.6.33 dies on modprobe
Message-ID: <20100301090708.GF17929@forwiss.uni-passau.de>
Mail-Followup-To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
	linux-kernel@vger.kernel.org,
	Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20100228221257.GA8858@invalid> <2375c9f91002282022n29e83858jd8cadbb2e664b436@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2375c9f91002282022n29e83858jd8cadbb2e664b436@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-purgate: This mail is considered clean
X-purgate: clean
X-purgate-type: clean
X-purgate-Ad: Checked for Spam by eleven - eXpurgate www.eXpurgate.net
X-purgate-ID: 151291::100301100708-4D6C0001-F0BD4BF1/0-0/0-1
X-purgate-size: 1312/1216
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am Montag, den 01. März schrieb Américo Wang:
> On Mon, Mar 1, 2010 at 6:12 AM, M G Berberich
> <berberic@fmi.uni-passau.de> wrote:

> > I tried to build a 2.6.33 kernel but on boot it dies on modprobe
> > (kernel-Oops). This might be the result of faulty config, but I'm
> > totaly clueless what's the fault.
> >
> > The kernel starts up fine and mounts the root-filesystem, but then
> > dies on the first modprobe executed. I can boot it with init=/bin/bash
> > and get a working bash (until I do modprobe on any module).
> >
> > System is a Gigabyte M55S-S3 rev 2.0 (nForce 550) with an AMD Athlon64
> > X2 5000+ and amd64-kernel architecture. kernel-sources are from
> > kernel.org.

> It seems something is wrong with forcedeth code or PCI code.
> Adding some Cc's.

I don't think it's forcedeth. forcedeth just happens to be the first
module that get's loaded in startup. It crashes with any other module
too (I tried ohci_hcd). 

To repeat myself: This might be the result of faulty config

	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | berberic@fmi.uni-passau.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | www.fmi.uni-passau.de/~berberic

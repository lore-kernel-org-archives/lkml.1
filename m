Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbXIYRJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbXIYRJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbXIYRJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:09:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39123 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbXIYRJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:09:40 -0400
Date: Tue, 25 Sep 2007 18:09:33 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Miloslav Semler <majkls@prepere.com>, serge@hallyn.com, davidsen@tmr.com,
       philipp@marek.priv.at, 7eggert@gmx.de, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
Message-ID: <20070925170933.GJ8181@ftp.linux.org.uk>
References: <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <Pine.LNX.4.64.0709251715390.945@fbirervta.pbzchgretzou.qr> <46F92C17.3060405@davidnewall.com> <Pine.LNX.4.64.0709251748240.945@fbirervta.pbzchgretzou.qr> <46F9351D.8020906@prepere.com> <Pine.LNX.4.64.0709251847570.945@fbirervta.pbzchgretzou.qr> <46F93EAF.20706@prepere.com> <Pine.LNX.4.64.0709251903480.945@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709251903480.945@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 07:05:06PM +0200, Jan Engelhardt wrote:

> Perhaps that was formulated a bit sloppy. It of course means
> "On chroot(2), implicitly close all FDs that point outside."

Bollocks.  Pack 'em into SCM_RIGHTS datagram, send to yourself,
do chroot, recvmsg() and move on, cheerfully spitting at the
YAidiotic "hardening".

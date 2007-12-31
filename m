Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbXLaCue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbXLaCue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 21:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXLaCuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 21:50:24 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:49193 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbXLaCuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 21:50:23 -0500
Date: Mon, 31 Dec 2007 03:50:22 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jeff Garzik <jeff@garzik.org>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>
Subject: Re: Updated Kernel Hacker's guide to git
In-Reply-To: <476E42BF.1010300@garzik.org>
Message-ID: <Pine.LNX.4.64.0712310349260.2093@fbirervta.pbzchgretzou.qr>
References: <200612241807.kBOI746w008739@laptop13.inf.utfsm.cl>
 <476E42BF.1010300@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 23 2007 06:13, Jeff Garzik wrote:
> Another year, another update!  :)
>
> The kernel hacker's guide to git has received some updates:
>
> 	http://linux.yyz.us/git-howto.html
>

It says

"""Don't forget to download tags from time to time.

git pull only downloads sha1-indexed object data, and the requested
remote head. This misses updates to the .git/refs/tags/ and
.git/refs/heads/ directories. For tags, run git fetch --tags $URL."""


But when I do git pull on a simple tracking tree (e.g. git-clone
torvalds/linux-2.6.git; git pull;) it automatically grabs new tags.

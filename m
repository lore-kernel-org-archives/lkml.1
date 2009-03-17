Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbZCQXe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbZCQXe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 19:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZCQXes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 19:34:48 -0400
Received: from main.gmane.org ([80.91.229.2]:52456 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZCQXer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 19:34:47 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Russ Dill <Russ.Dill@gmail.com>
Subject: Re: [PATCH 0/3]: compressed in-memory swapping
Date: Tue, 17 Mar 2009 23:34:31 +0000 (UTC)
Message-ID: <loom.20090317T233246-703@post.gmane.org>
References: <49BF8ABC.6040805@vflare.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 70.176.253.20 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.0.7) Gecko/2009030516 Ubuntu/9.04 (jaunty) Firefox/3.0.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta <ngupta <at> vflare.org> writes:

> 
> Hi,
> 
> Project home: http://code.google.com/p/compcache/
> 
> It allows creating a RAM based block device which acts as swap disk.
> Pages swapped to this device are compressed and stored in memory itself.
> This is a big win over swapping to slow hard-disk which are typically used
> as swap disk. For flash, these suffer from wear-leveling issues when used
> as swap disk - so again its helpful. For swapless systems, it allows more
> apps to run.
> 

I would recommend making xvmalloc the 1/3 instead of 2/3 so that the commit is
bisectable.

I really like this project and I'm especially impressed with how the SSD ATAPI
discard command fell in nicely with the discard requirement for compcache.


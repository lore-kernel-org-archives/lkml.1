Return-Path: <linux-kernel-owner+w=401wt.eu-S1763629AbXFBWyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763629AbXFBWyV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761716AbXFBWyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:54:14 -0400
Received: from gw.goop.org ([64.81.55.164]:40703 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761670AbXFBWyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:54:14 -0400
Message-ID: <4661F511.4070207@goop.org>
Date: Sat, 02 Jun 2007 15:54:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Kernel 2.6.22-rc3 safe to migrate to?
References: <Pine.LNX.4.64.0706021723480.22318@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706021723480.22318@p34.internal.lan>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Wondering as their were a lot of XFS related issues early on in
> development..? The 2.6.22-rc3 kernel has the core 2 duo coretemp patch
> by ruik which I want be running as long as 2.6.22-rc3 does not have
> any severe XFS issues? 

XFS currently has a data-corrupting bug, where files which were appended
by small amounts may lose their updates on umount - I see this
corrupting hg repos. There's a patch which works for me, and is in
2.6.22-rc3-mm1, but it hasn't been merged upstream yet.

J

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbYCHO2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbYCHO2W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 09:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYCHO2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 09:28:13 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:55288 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbYCHO2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 09:28:12 -0500
Date: Sat, 8 Mar 2008 15:28:05 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Al Boldi <a1426z@gawab.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
In-Reply-To: <200803081710.24137.a1426z@gawab.com>
Message-ID: <alpine.DEB.1.00.0803081522240.7522@sheep.housecafe.de>
References: <200803081710.24137.a1426z@gawab.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Mar 2008, Al Boldi wrote:
> Nice try, but this only works on the surface.  Try remounting root to see what I mean.

Are you suggesting that hpa's init= thingy doesn't support remounting 
root? If so, it'd have to be mentioned in kernel-parameters.txt as well.

> Now, for a patch that actually does what we want, try this:
> [PATCH][retry-2] init: Introduce rootdir bootparm to select which dir
> to sys_chroot

I didn't intend to introduce another bootparam, because of -ENOSKILL.
But somewhere in this thread is a patch for the chroot= bootparam, I
have not tested it though...

C.
-- 
BOFH excuse #93:

Feature not yet implemented

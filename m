Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbZHJUIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbZHJUIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZHJUIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:08:36 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:43500 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbZHJUIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:08:36 -0400
Message-ID: <4A807E3A.8050703@free.fr>
Date: Mon, 10 Aug 2009 22:08:26 +0200
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.9.1.1pre) Gecko/20090717 SeaMonkey/2.0b1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: linux-next: reiserfs lockout with xattr ?
References: <4A79CA90.8080101@free.fr> <20090808002726.GI4999@nowhere> <4A7E9C63.4090400@free.fr> <20090809233302.GD6089@nowhere>
In-Reply-To: <20090809233302.GD6089@nowhere>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 10/08/2009 01:33, Frederic Weisbecker a écrit :
> 
> Thanks a lot for this report. Reiserfs xattrs are definetly paths I
> haven't tested deeply.
> 
> I'm trying to reproduce these issues and will let you know once I get
> a fix.
> 
> (Btw, if you're still running this tree, you should update with the
> latest patch I just pushed, it's a very important fix).
> 
> Thanks,
> 
> Frederic.

I tried with your lastest patch (git head is at "kill-the-bkl/reiserfs: 
fix early readdir offset increment"), and the lockout still happens.

~~
laurent

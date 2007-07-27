Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbXG0ESh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbXG0ESh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 00:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbXG0ESb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 00:18:31 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:23502 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbXG0ESa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 00:18:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=RYXcdGlm65hDJX0iYDMlUagcKhAeaL0zF50PEr+ovjamM/Qz/xKfhydPttsISw1Y5fzVH1sX80/FxZOIyCJGLw2G2iEm7h8F/9Ary6rbbK1A7ZWRYO/xejTyrIO5JiFKuqZjVYsSe8Pn9YC6nMt0lD9AUgJHhhbBCgS5tWK8xgA=
Message-ID: <46A97210.1090605@gmail.com>
Date: Fri, 27 Jul 2007 13:18:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 8535] USB input death then system freeze
References: <Pine.LNX.4.44L0.0707261022260.3529-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707261022260.3529-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> Tejun:
> 
> Please take a look at comment #50 in Bugzilla 8535:
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=8535#c50
> 
> There have been several reports like this one recently of BUGs
> occurring in release_sysfs_dirent() during device unregistration.  
> Obviously a use-after-free issue, probably caused by a refcounting 
> error.
> 
> Is there already a patch available to fix it?

http://article.gmane.org/gmane.linux.kernel/556682/raw

Does this patch fix the problem?

-- 
tejun

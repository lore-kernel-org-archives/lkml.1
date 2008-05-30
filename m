Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYE3TYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYE3TYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 15:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbYE3TYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 15:24:14 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:6403 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbYE3TYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 15:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L7h4TkeEGXO6IQBd+VWLcIFu8TL1RWjA9HBl3t4m2GVWclG4RQIUNFzaebafRW4gSCmX6YHQFC5aZfOFHscdjAkoOCXysGwxPu7FjfAKm9fqs1NUdsErAu1a4cQbiRbejGUsCsCB378Y2eUJNIPO0hplFPWNs9APUwZoXY+0uVg=
Message-ID: <6934efce0805301224t5e5d7a01n3b652c4df5324d58@mail.gmail.com>
Date: Fri, 30 May 2008 12:24:11 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Alexey Korolev" <akorolev@infradead.org>
Subject: Re: [BUG] JFFS2 power loss recovery issues in 2.6.25, 2.6.26-rc
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0805291205480.22130@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0805291205480.22130@pentafluge.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We made some investigations for this issue and found commit number which
> breaks JFFS2 power loss recoverability.
> It is:  [JFFS2] Improve getdents vs. f_pos handling on NOR flash.
>        http://git.infradead.org/mtd-2.6.git?a=commitdiff;h=15953580e79b58caefb107e77f218e009b9992e6
>
> Currently we don't know why it breaks JFFS2 and how it could be fixed
> except roll back.

Does everything work when you unmerge this one commit?

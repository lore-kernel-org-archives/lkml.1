Return-Path: <linux-kernel-owner+w=401wt.eu-S1750824AbXA3Kul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750824AbXA3Kul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 05:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbXA3Kul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 05:50:41 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:37063 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbXA3Kul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 05:50:41 -0500
Date: Tue, 30 Jan 2007 11:48:38 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Josh Triplett <josh@kernel.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] cdev.h needs struct inode; add forward declaration
In-Reply-To: <45BE5297.4070608@kernel.org>
Message-ID: <Pine.LNX.4.61.0701301148130.23321@yvahk01.tjqt.qr>
References: <45BE5297.4070608@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>include/linux/cdev.h defines cd_forget to take a struct inode *, but does not
>pull in any definition or declaration for struct inode.  This generates a
>compiler warning if a source file pulls in cdev.h without first pulling in
>fs.h.  Add a forward declaration of struct inode to cdev.h, to eliminate the
>compiler warning and preserve the ability to include headers in any arbitrary
>order.

We've been over this: http://lkml.org/lkml/2007/1/19/119
The patch went in into -mm and out again (why? - no reason was 
attached, Andrew.)


Jan
-- 
ft: http://freshmeat.net/p/chaostables/

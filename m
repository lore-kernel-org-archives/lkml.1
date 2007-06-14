Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbXFNTpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbXFNTpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbXFNToJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:44:09 -0400
Received: from smtp.regionline.fi ([85.157.255.99]:52922 "EHLO
	smtp.regionline.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452AbXFNToI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:44:08 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 15:44:07 EDT
From: Jan Knutar <jk-lkml@sci.fi>
To: linux-kernel@vger.kernel.org
Subject: Re: ext2 on flash memory
Date: Thu, 14 Jun 2007 22:36:55 +0300
User-Agent: KMail/1.6.2
Cc: DervishD <lkml@dervishd.net>, Juergen Beisert <juergen127@kreuzholzen.de>
References: <20070611101319.GA14284@DervishD> <200706112127.42119.juergen127@kreuzholzen.de> <20070613134843.GC1983@DervishD>
In-Reply-To: <20070613134843.GC1983@DervishD>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200706142236.56195.jk-lkml@sci.fi>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 16:48, DervishD wrote:
>     But anyway the memory should last long. Even cheap flash memories
> with poor wear leveling (if any at all) usually long last. Given that
> I won't be writing continuously, wear shouldn't be a problem. I'm
> going to use this as a backup copy of my home. Of course, I can use a
> tarball too...

I did a test on my kingston datatraveler recently, I didn't expect it to 
survive, but it did. I put reiserfs on it, and copied 394M of data in 
200,000 files to it. Reiserfs was sloooow at writing, the device was 
probably doing alot of work. ext2 was about 10X faster, but there was 
hardly any free space left at all at the end :)

Considering it surived ReiserFS, I suspect it would last ages with ext2, 
especially for your backup purposes.

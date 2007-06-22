Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbXFVJU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbXFVJU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 05:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbXFVJUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 05:20:21 -0400
Received: from lazybastard.de ([212.112.238.170]:48668 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbXFVJUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 05:20:20 -0400
Date: Fri, 22 Jun 2007 11:15:20 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: James Bruce <bruce@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: TUX2 filesystem
Message-ID: <20070622091520.GB17988@lazybastard.org>
References: <200706210705.34702.philipp.marek@bmlv.gv.at> <467ABBFB.5080108@andrew.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <467ABBFB.5080108@andrew.cmu.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 June 2007 13:57:15 -0400, James Bruce wrote:
> 
> efficient atomic snapshots on a filesystem.  There are still some issues 
> with unexpected disk space usage (it requires _additional_ disk space to 
> _delete_ a file), and it tends to use more memory (you want to delay 
> client writes as much as possible, so you can allocate later and copy 
> the least amount necessary)

The delete issue really surprised me.  It is so obvious and simple to
solve that it hardly deserves mentioning.  And yet ZFS allegedly hasn't
solved it yet - scary.

Additional memory isn't strictly required either.  It just helps to
delay writes as long as possible to fight fragmentation.

Jörn

-- 
Joern's library part 9:
http://www.scl.ameslab.gov/Publications/Gus/TwelveWays.html

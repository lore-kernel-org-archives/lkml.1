Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbZANWad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbZANWad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZANWaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:30:22 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:61181 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753747AbZANWaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:30:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuQCAG/0bUl5LDnlgWdsb2JhbACTfgEBFiK7E4Vv
X-IronPort-AV: E=Sophos;i="4.37,263,1231075800"; 
   d="scan'208";a="293864527"
Date: Thu, 15 Jan 2009 09:30:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: wk <handygewinnspiel@gmx.de>
Cc: Chris Mason <chris.mason@oracle.com>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl, HWerner4@gmx.de,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mchehab@infradead.org
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
Message-ID: <20090114223016.GY8071@disturbed>
Mail-Followup-To: wk <handygewinnspiel@gmx.de>,
	Chris Mason <chris.mason@oracle.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
	HWerner4@gmx.de, viro@zeniv.linux.org.uk,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	mchehab@infradead.org
References: <20090112132130.6c932b85.akpm@linux-foundation.org> <20090112220624.4fbfee34@pedra.chehab.org> <20090112162337.318dd61d.akpm@linux-foundation.org> <20090113184755.87720@gmx.net> <20090113105947.9e774b69.akpm@linux-foundation.org> <20090113191757.74290@gmx.net> <20090113113700.776a94b5.akpm@linux-foundation.org> <20090113203843.GJ29283@parisc-linux.org> <1231957750.8269.28.camel@think.oraclecorp.com> <496E56EB.2030301@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496E56EB.2030301@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 10:19:39PM +0100, wk wrote:
> Chris Mason wrote:
> I cannot fully understand what strace -v outputs (see attachment), but  
> what i see is that 'find' stops after finding a file with d_off = 
> 4294967295
> 4294967295  =  0xFFFFFFFF, adding any number greater that zero will be  
> greater that 32bits, so this could be the reason for the message "value  
> too large".
>
>
>
> I also noticed that i cannot access these files through samba if i boot  
> from 2.6.28 - really strange.
> If i reboot older kernels these are visible in samba again and fully  
> accessible.
>
> Attached the log from stracing the command which was ivoked by the  
> Makefile from v4l-dvb.
> I guess this is all i could contribute to that problem. Thats stuff for  
> xfs filesystem experts now..

It's obviously the regression fixed by:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=commit;h=15440319767942a363f282d6585303d3d75088ba

It needs to be pushed to Linus, then into 2.6.28-stable.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

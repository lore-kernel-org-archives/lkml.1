Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYIEUFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYIEUFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 16:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYIEUE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 16:04:56 -0400
Received: from quackingmoose.com ([63.73.180.143]:40142 "EHLO
	penguin.merfinllc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751270AbYIEUE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 16:04:56 -0400
Date: Fri, 5 Sep 2008 13:04:55 -0700
From: Aaron Straus <aaron@merfinllc.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Neil Brown <neilb@suse.de>,
       Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [NFS] blocks of zeros (NULLs) in NFS files in kernels >= 2.6.20
Message-ID: <20080905200455.GH22796@merfinllc.com>
References: <20080905191939.GG22796@merfinllc.com> <0A24B45A-9761-4310-B1DB-B4738964E862@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0A24B45A-9761-4310-B1DB-B4738964E862@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sep 05 03:56 PM, Chuck Lever wrote:
> [ replacing cc: nfs@sf.net with linux-nfs@vger.kernel.org, and neil's  
> old address with his current one ]

Sorry I probably grabbed an old MAINTAINERS file.

> On Sep 5, 2008, at Sep 5, 2008, 3:19 PM, Aaron Straus wrote:
> > Writer_Version     Outcome:
> > <= 2.6.19          OK
> > >= 2.6.20	    BAD
> 
> Up to which kernel?  Recent ones may address this issue already.

BAD up to 2.6.27-rc? 

I have to see exactly which is the last rc version I tested.

> > I can try to bisect between 2.6.19 <-> 2.6.20.
> 
> That's a good start.

OK will try to bisect.

> Comparing a wire trace with strace output, starting with the writing  
> client, might also be illuminating.  We prefer wireshark as it uses  
> good default trace settings, parses the wire bytes and displays them  
> coherently, and allows you to sort the frames in various useful ways.

OK.  Could you also try to reproduce on your side using those python
programs?  I want to make sure it's not something specific with our
mounts, etc.

Thanks!
					=a=


-- 
===================
Aaron Straus
aaron@merfinllc.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbXI0OdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbXI0OdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbXI0OdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:33:03 -0400
Received: from mail.tmr.com ([64.65.253.246]:59979 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbXI0OdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:33:00 -0400
Message-ID: <46FBBFD5.6050702@tmr.com>
Date: Thu, 27 Sep 2007 10:36:05 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Christer Weinigel <christer@weinigel.se>,
       David Newall <david@davidnewall.com>, Al Viro <viro@ftp.linux.org.uk>,
       Phillip Susi <psusi@cfl.rr.com>, Bill Davidsen <davidsen@tmr.com>,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
References: <20070919194559.36015307@the-village.bc.nu> <46F1A196.8060108@davidnewall.com> <46F401D6.6060609@cfl.rr.com> <20070921191012.15a0b51b@the-village.bc.nu> <46F9752C.5080807@cfl.rr.com> <20070926002340.GL8181@ftp.linux.org.uk> <46FA35A6.1070400@davidnewall.com> <20070926212408.6662231a@zoo.weinigel.se> <46FACCE0.2070005@davidnewall.com> <20070927092808.612c204b@localhost.localdomain> <20070927112316.GC18346@thunk.org>
In-Reply-To: <20070927112316.GC18346@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Thu, Sep 27, 2007 at 09:28:08AM +0200, Christer Weinigel wrote:
>   
>> So the OpenBSD man page seems to be in the minority here.  Any portable
>> code can not assume that CWD changes.  And changing the Linux behaviour
>> now would be a rather big change which might break userspace.  And yes,
>> there are applications that rely on this, I've used it when building
>> software for cross compiling.  
>>     
>
> Changing Linux behavior would violate the POSIX and SuSV2
> specifications; the standards explicitly state that the working
> directory will NOT change.  And standards adherance is important; we
> break them only if we have a d*mn good reason.  And trying to make
> chroot() something which it is not (i.e., a secure jail) is certainly
> not a good enough reason.
>
> Can we please end this thread now?  And can we put in a Kernel FAQ
> saying that this is not something which is NOT up for discussion?
>   
It seems there are (at least) two parts to this, one regarding changing 
working directory which is clearly stated in the standards and must work 
as it does, and the various issues regarding getting out of the chroot 
after the cwd has entered that changed root. That second part seems to 
offer room for additional controls on getting out of the chroot which do 
not violate any of the obvious standards, and which therefore might be 
valid candidates for discussion on the basis of benefit rather than 
portability.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979


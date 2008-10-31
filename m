Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbYJaTDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbYJaTDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 15:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYJaTDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 15:03:45 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:57224 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbYJaTDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 15:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=bGL/qbAwIN5zEC+5uKdmREYt+DXPXrDGYa9aFfDocRJj/GfQ0k/KElINVj6WQ70NT+
         z/8pwStIQ/XbG50qGFDCOOxVValWuvHsQkklsAVUw5bPHnL3gViQsFoL2eZrRUEJFg8G
         4wwKwdlp5hrSG36aSdDz/abJPOAOEsATHsgY8=
Date: Fri, 31 Oct 2008 21:06:04 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: build issue #576 for v2.6.28-rc2-385-g721d5df :'boot_cpu_id'
	undeclared
Message-ID: <20081031180604.GB20803@localhost>
References: <200810311702.36706.toralf.foerster@gmx.de> <20081031175504.GG3235@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081031175504.GG3235@hack.voiplan.pt>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Américo Wang - Fri, Oct 31, 2008 at 05:55:04PM +0000]
| On Fri, Oct 31, 2008 at 05:02:33PM +0100, Toralf Förster wrote:
| >Hello,
| >
| >the build (.config attached) failed, make ends with :
| >...
| >  CC      arch/x86/kernel/cpu/capflags.o
| >  CC      arch/x86/kernel/cpu/powerflags.o
| >  CC      arch/x86/kernel/cpu/common.o
| >arch/x86/kernel/cpu/common.c: In function 'cpu_init':
| >arch/x86/kernel/cpu/common.c:1141: error: 'boot_cpu_id' undeclared (first use 
| >in this function)
| >arch/x86/kernel/cpu/common.c:1141: error: (Each undeclared identifier is 
| >reported only once
| >arch/x86/kernel/cpu/common.c:1141: error: for each function it appears in.)
| >make[2]: *** [arch/x86/kernel/cpu/common.o] Error 1
| >make[1]: *** [arch/x86/kernel/cpu] Error 2
| >make: *** [arch/x86/kernel] Error 2
| 
| Probably fixed by:
| 
| http://lkml.org/lkml/2008/10/30/459
| 
| -- 
| "Sometimes the only way to stay sane is to go a little crazy."
| 
| 

ah...indeed!

		- Cyrill -

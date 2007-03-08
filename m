Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbXCHLoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbXCHLoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 06:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbXCHLoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 06:44:38 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39427 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751431AbXCHLoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 06:44:37 -0500
Date: Thu, 8 Mar 2007 12:44:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       rjw@sisk.pl
Subject: Re: [PATCH 12/20] x86_64: 64bit ACPI wakeup trampoline
Message-ID: <20070308114422.GE5953@elf.ucw.cz>
References: <20070307065703.GA23412@in.ibm.com> <20070307071458.GM23412@in.ibm.com> <20070307224508.GE5956@elf.ucw.cz> <20070308045841.GF6000@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308045841.GF6000@in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ...you'll still keep 80-column rule while keeping it readable.
> > 
> 
> Thanks. Done the changes in attached patch.
> 
> > > @@ -159,11 +159,11 @@ wakeup_32:
> > >  	 */
> > >  
> > >  	/* Finally jump in 64bit mode */
> > > -	ljmp	*(wakeup_long64_vector - __START_KERNEL_map)
> > > +        ljmp    *(wakeup_long64_vector - wakeup_code)(%esi)
> > 
> > spaces vs. tabs problem.
> > 
> 
> Thanks. Done the changes in attached patch.
...
> o Increased the size of the wakeup routine to 8K. This is required as
>   wake page tables are on trampoline itself and they got to be at 4K
>   boundary, hence one page is not sufficient.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>

ACK.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

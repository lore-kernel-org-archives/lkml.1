Return-Path: <linux-kernel-owner+w=401wt.eu-S2992699AbXCGWlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992699AbXCGWlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992691AbXCGWlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:41:22 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44069 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992693AbXCGWlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:41:14 -0500
Date: Wed, 7 Mar 2007 23:40:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       rjw@sisk.pl
Subject: Re: [PATCH 11/20] x86_64: wakeup.S misc cleanups
Message-ID: <20070307224053.GC5956@elf.ucw.cz>
References: <20070307065703.GA23412@in.ibm.com> <20070307071320.GL23412@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307071320.GL23412@in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> o Various cleanups. One of the main purpose of cleanups is that make
>   wakeup.S as close as possible to trampoline.S.
> 
> o Following are the changes
> 	- Indentations for comments.
> 	- Changed the gdt table to compact form and to resemble the
> 	  one in trampoline.S
> 	- Take the jump to 32bit from real mode using ljmpl. Makes code
> 	  more readable.
> 	- After enabling long mode, directly take a long jump for 64bit
> 	  mode. No need to take an extra jump to "reach_comaptibility_mode"
> 	- Stack is not used after real mode. So don't load stack in
>  	  32 bit mode.
> 	- No need to enable PGE here.
> 	- No need to do extra EFER read, anyway we trash the read contents.
> 	- No need to enable system call (EFER_SCE). Anyway it will be 
> 	  enabled when original EFER is restored.
> 	- No need to set MP, ET, NE, WP, AM bits in cr0. Very soon we will
>   	  reload the original cr0 while restroing the processor state.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>

ACK, provided it was tested.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

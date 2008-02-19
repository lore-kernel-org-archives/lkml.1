Return-Path: <linux-kernel-owner+w=401wt.eu-S1762429AbYBTAC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762429AbYBTAC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbYBTACT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:02:19 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41312 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487AbYBTACS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:02:18 -0500
Date: Tue, 19 Feb 2008 15:59:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alexn@dsv.su.se" <alexn@dsv.su.se>,
       "dwalker@mvista.com" <dwalker@mvista.com>
Subject: Re: 2.6.25-rc2-mm1: new create_proc_entry() users
Message-Id: <20080219155902.759604a2.akpm@linux-foundation.org>
In-Reply-To: <DEE40752C8AF224BB890E455C7B8E0FE0427C1CB86@G6W0268.americas.hpqcorp.net>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<20080217105050.GC6596@martell.zuzino.mipt.ru>
	<DEE40752C8AF224BB890E455C7B8E0FE0427C1CB86@G6W0268.americas.hpqcorp.net>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 22:25:00 +0000 "Miller, Mike (OS Dev)" <Mike.Miller@hp.com> wrote:

> 
> 
> > -----Original Message-----
> > From: Alexey Dobriyan [mailto:adobriyan@gmail.com]
> > Sent: Sunday, February 17, 2008 4:51 AM
> > To: Andrew Morton
> > Cc: linux-kernel@vger.kernel.org; Miller, Mike (OS Dev);
> > alexn@dsv.su.se; dwalker@mvista.com
> > Subject: 2.6.25-rc2-mm1: new create_proc_entry() users
> >
> > > profile-likely-unlikely-macros
> > > page-owner-tracking-leak-detector
> > > cciss-procfs-updates-to-display-info-about-many-volumes
> >
> > Guys, create_proc_entry() is slightly racy in case of modular code and
> > proc_create() was invented to fix it. Eventually all
> > create_proc_entry() users will be converted to proc_create(),
> > so please do it for new code.
> >
> Why am I getting "implicit declaration of function 'proc_create'" when I try to use that function? I have kernel version 2.6.24, gcc version 4.1.1 20070105 (Red Hat 4.1.1-51). Am I missing a header file?
> 

2.6.24 is 47MB of diff ago.  Please always develop and test against
development kernels!

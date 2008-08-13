Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbYHMN7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbYHMN7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 09:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbYHMN6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 09:58:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:44097 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbYHMN6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:58:51 -0400
Date: Wed, 13 Aug 2008 06:58:54 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@suse.cz>
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>, davecb@sun.com,
       Mihai Don??u <mdontu@bitdefender.com>, Adrian Bunk <bunk@kernel.org>,
       tvrtko.ursulin@sophos.com, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon
 access scanning
Message-ID: <20080813065854.10bd9b06@infradead.org>
In-Reply-To: <20080813125638.GB6995@ucw.cz>
References: <20080806105008.GF6477@cs181140183.pp.htv.fi>
	<200808070349.55882.mdontu@bitdefender.com>
	<20080806213904.37a33a58@infradead.org>
	<200808111645.48177.mdontu@bitdefender.com>
	<20080811065608.44687f65@infradead.org>
	<48A0649B.4010706@sun.com>
	<2629CC4E1D22A64593B02C43E855530304AE4B80@USILMS12.ca.com>
	<20080813102802.GC27074@atrey.karlin.mff.cuni.cz>
	<2629CC4E1D22A64593B02C43E855530304AE4BA4@USILMS12.ca.com>
	<20080813125638.GB6995@ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 14:56:38 +0200
Pavel Machek <pavel@suse.cz> wrote:
> So you make sure all apps are modified. Distros are good at that, and
> modifications are not that hard.
> 
> Plus, proposed solution already has three unacceptable holes:
> 
> 1) it only catches known signatures
> 
> 2) write vs. read race mentioned above
> 
> 3) mmap problem
> 
> . Making sure all apps use libmalware.so is trivial compared to
> solving 3).

the other thing is.. all applications ALREADY use such a library. It's
called "glibc".



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

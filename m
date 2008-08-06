Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbYHFPCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbYHFPCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbYHFPCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:02:05 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40614 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754883AbYHFPCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:02:04 -0400
Date: Wed, 6 Aug 2008 11:00:54 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: tvrtko.ursulin@sophos.com
Cc: Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, "Press, Jonathan" <Jonathan.Press@ca.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
	linuxinterfaceforon access scanning
Message-ID: <20080806150054.GC14109@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, tvrtko.ursulin@sophos.com,
	Adrian Bunk <bunk@kernel.org>,
	Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
	"Press, Jonathan" <Jonathan.Press@ca.com>,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	malware-list@lists.printk.net
References: <20080806105008.GF6477@cs181140183.pp.htv.fi> <20080806110851.C2DBC3764CE@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806110851.C2DBC3764CE@pmx1.sophos.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 12:07:57PM +0100, tvrtko.ursulin@sophos.com wrote:
> > - Some set of requirements suddenly appears out of the void on 
> >   linux-kernel.
> 
> Because previously it was said to go away and come back with a clear list 
> of requirements. And here you make it sound like a negative thing. See 
> what I am talking about?

The list of requirements you came up with was a very low-level set of
requirements.  This is why Al Viro called it not much better than we
want a bunch of hooks here, here, and here.

What is needed is the high-level set of requirements --- which in the
case of security fixes, really needs to start with a threat model (or
threat models).  See my previous message, where I tried to help you
guys out on this.  There are scenarios such as "The Linux Desktop",
where the Clueless User may be tricked to run random binaries.  Then
there is the "The Linux Fileserver", where users may upload malware
via CIFS, NFS, et. al, but there aren't any Clueless Users to start
the malware running on said Linux Fileserver, etc.  When you do threat
analysis you need to know whether the malware is likely to have
compromised root (superuser) access or not.   Etc.

Low-level requirements are things like "this code must take the
number, multiply by it 7, and add 42".  High-level requirements answer
the question, why the heck are you trying to do this in the first
place?!?

						- Ted

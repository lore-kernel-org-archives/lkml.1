Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbYHTVBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbYHTVBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbYHTVBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:01:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbYHTVBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:01:41 -0400
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro
	linux interface for  for access scanning
From: Eric Paris <eparis@redhat.com>
To: david@lang.hm
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       tvrtko.ursulin@sophos.com, Theodore Tso <tytso@mit.edu>, davecb@Sun.COM,
       Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0808201004200.20991@asgard.lang.hm>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>
	 <1219076143.15566.39.camel@localhost.localdomain>
	 <20080818171500.78590801@lxorguk.ukuu.org.uk>
	 <1219080504.15566.65.camel@localhost.localdomain>
	 <20080818182556.13ced58f@lxorguk.ukuu.org.uk>
	 <1219082097.15566.82.camel@localhost.localdomain>
	 <20080818183540.GA5470@cs.cmu.edu>
	 <1219085176.15566.100.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0808181159400.15109@asgard.lang.hm>
	 <alpine.DEB.1.10.0808191906270.20991@asgard.lang.hm>
	 <1219245321.3389.82.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0808201004200.20991@asgard.lang.hm>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 15:26:07 -0400
Message-Id: <1219260367.3389.125.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 10:33 -0700, david@lang.hm wrote:

> if the system package manager says the syslogd binary doesn't match the 
> checksum that it has recorded should it be prevented from running? (a 
> strict policy would say no, but the sysadmin may have recompiled that one 
> binary and just wants a warning to be logged somewhere, not preventing the 
> process from running)

My belief is that if you choose to run a file scanner and that file
scanner gets the answer wrong you need to look at the file scanner.
There shouldn't be arbitrary overrides.  If you don't accept the results
of the scanner what's the point?  Tell you package manager scanner that
you changed it.

> without the kernel support to clear the flags when the file is dirtied how 
> can these programs trust the xattr flags that say they scanned the file 
> before?

I don't understand what you mean about trust.  This is an argument for
kernel support now?  What is it that you say needs and what doesn't need
it?  Can you explain exactly what your perfect solution from top down?

> I'm not saying that xattr is the only way to store the info, it just seems 
> like a convienient place to store them without having to create a 
> completely new API or changing anything in on-disk formats.

And I saying we don't actually need any of this and if it is actually
needed by someone in the real world they can easily build their own
solution on top of my generic interface.  I'm not making the assertion
it is race free and don't think it is possible without making every
sequential (hahahaha.)  But I claim in the face of normal operation it's
fine.  My interface, as proposed, is very generic.  Much more so than
what I think you are trying to describe.  I couldn't make mine more
minimal or broad.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbZDNM30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbZDNM30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 08:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbZDNM3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:29:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:2557 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbZDNM3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V7tNRs4QDIN+A45QiedTBYH06HB0TLs+3G1vd9+ThrID9QiuOTYfB/5tnU2cTXooN8
         CjzHCopUmXEbhtlTC1T6JKa+08cdoscXSawrc0kbCwO5jxrh8z8eYzyhJUwsvJXOmVEN
         /D9mHtcvdRvwkUxDj9P9s5PslbrCiAkA3X0Xw=
Date: Tue, 14 Apr 2009 16:29:06 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
Message-ID: <20090414122906.GA20201@x200.localdomain>
References: <20090410023207.GA27788@x200.localdomain> <alpine.LFD.2.00.0904100758410.4583@localhost.localdomain> <20090413073925.GB7085@x200.localdomain> <alpine.LFD.2.00.0904131137520.26713@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904131137520.26713@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 11:39:51AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 13 Apr 2009, Alexey Dobriyan wrote:
> > 
> > Well, in OpenVZ everything is in kernel/cpt/ and prefixed with "cpt_"
> > and "rst_".
> 
> So?
> 
> We're not merging OpenVZ code _either_.

This is to give example of other prefixes: cpt_ and rst_
Are they fine?

> > And I think "cr_" is super nice prefix: it's short, it's C-like,
> > it reminds about restart part
> 
> It does no such thing. THAT'S THE POINT. "cr" means _nothing_ to anybody 
> else than some CR-specific people, and those people don't even need it!
> 
> Look around you. We try to use nicer names. We spell out "cpufreq", we 
> don't call it "cf".

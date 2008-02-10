Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbYBJKto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbYBJKto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 05:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbYBJKtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 05:49:35 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:60875 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935AbYBJKtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 05:49:35 -0500
Date: Sun, 10 Feb 2008 11:49:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Hansen <haveblue@us.ibm.com>, Avi Kivity <avi@argo.co.il>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH] make KVM selectable again
Message-ID: <20080210104941.GC10790@uranus.ravnborg.org>
References: <1202590755.14165.11.camel@nimitz.home.sr71.net> <20080209212401.GA13888@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080209212401.GA13888@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 10:24:01PM +0100, Ingo Molnar wrote:
> 
> * Dave Hansen <haveblue@us.ibm.com> wrote:
> 
> >  config HAVE_SETUP_PER_CPU_AREA
> >  	def_bool X86_64
> >  
> > -select HAVE_KVM
> > +config HAVE_KVM
> > +	def_bool y
> 
> i think it might be better to just move the select to after the "config 
> X86" option. (this is a legitimate use of select) Sam, do you concur?

Correct.
We should see it used like this:

config X86
	select HAVE_KVM

	Sam

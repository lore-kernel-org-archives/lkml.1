Return-Path: <linux-kernel-owner+w=401wt.eu-S1763463AbYEPTKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763463AbYEPTKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758667AbYEPTKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:10:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758457AbYEPTKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:10:22 -0400
Date: Fri, 16 May 2008 16:10:15 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH][PCI]: Introduce pci_find_capability_cached and make
	MSI use it
Message-ID: <20080516191015.GB8111@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-rt-users@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>
References: <20080515160426.GD14846@ghostprotocols.net> <200805161044.34938.jbarnes@virtuousgeek.org> <20080516183356.GA7307@ghostprotocols.net> <200805161201.48644.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805161201.48644.jbarnes@virtuousgeek.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 16, 2008 at 12:01:48PM -0700, Jesse Barnes escreveu:
> On Friday, May 16, 2008 11:33 am Arnaldo Carvalho de Melo wrote:
> > > There are a few other common cap checks, but I don't think they compare
> > > to MSI in terms of latency sensitivity (though I didn't audit all the
> > > CAP_ID_EXP checks, there are quite a few of those).
> > >
> > > Since we know MSI is a problem, let's just go with fixing that for now. 
> > > If we find that other caps are also causing problems we can revisit
> > > caching all of them; the patch is simple enough.
> >
> > Do you want me to submit another patch or can you cook up one?
> 
> I can hack it up, probably not until Monday though (I'll be out of town this 
> weekend).

OK, for now this patch should be in the next rt patchset, we'll drop it
when you get The Right Thing merged 8)

- Arnaldo

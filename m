Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbXHJHjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbXHJHjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 03:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbXHJHjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 03:39:31 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60494 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbXHJHja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 03:39:30 -0400
Date: Fri, 10 Aug 2007 09:40:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: =?iso-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
Message-ID: <20070810074047.GC31307@uranus.ravnborg.org>
References: <20070809113122.3aa508e4@oldman.hamilton.local> <200708091508.20626.hjk@linutronix.de> <p73hcn8g25m.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <p73hcn8g25m.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 05:26:13PM +0200, Andi Kleen wrote:
> Hans-Jürgen Koch <hjk@linutronix.de> writes:
> 
> > Am Donnerstag 09 August 2007 12:31 schrieb Stephen Hemminger:
> > > Since the network device documentation needs a rewrite, I was thinking
> > > of using basic html format instead of just plain text. 
> > 
> > Why don't you simply use DocBook? Then the user has the choice to convert
> > to HTML, PDF, LaTex or whatever.
> 
> In my experience it tends to be challenging to actually find all the packages
> needed for that. And then it's incredibly slow -- seems to be much slower
> than gcc which is somewhat of an archivement. And at least for LinuxDoc TeX usually 
> can't even compile the result.
> 
> I would say the track record of existing DocBook deployment is not good enough
> to justify further use. Plain html can be converted into all these
> formats easily too and overall it makes a much nicer user experience.
> 
> Also I would expect much more people will know how to write html versus
> DocBook.

Documentation should be easy to access and readable in the source format.
For this purpose asciidoc seems to do a good job.

It is btw. discussed at git ML if they should shift due to toolset being
slow but that happens to be the docbook utilities. asciidoc seems to be fast enough.
And it can produce both HTML and docbook so seems to cover all cases.

	Sam

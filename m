Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbXITWDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbXITWDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXITWDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:03:10 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43523
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752345AbXITWDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:03:08 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-tiny@selenic.com
Subject: Re: [Celinux-dev] [Announce] Linux-tiny project revival
Date: Thu, 20 Sep 2007 18:02:58 -0500
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
References: <46F1645D.9050406@am.sony.com> <20070919142805.e0242fcf.akpm@linux-foundation.org>
In-Reply-To: <20070919142805.e0242fcf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201802.58611.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2007 4:28:05 pm Andrew Morton wrote:
> On Wed, 19 Sep 2007 11:03:09 -0700
>
> Tim Bird <tim.bird@am.sony.com> wrote:
> > Recently, the CE Linux forum has been working to revive the
> > Linux-tiny project.  At OLS, I asked for interested parties
> > to volunteer to become the new maintainer for the Linux-tiny patchset.
>
> I volunteer!  Send patches to me, cc linux-kernel and celinuv-dev.
>
> Seriously, putting this stuff into some private patch collection should
> be a complete last resort - you should only do this with patches which
> you (and the rest of us) agree have no hope of ever getting into mainline.

History!

<computer historian hat on>

The -tiny tree started out as a separate patch kit of Matt Mackall's, which he 
stopped updating circa 2.6.14 because he didn't think keeping them out of 
tree was helping attract other developers, nor was it helping to get them 
inline.  He decided to focus on pushing the existing patches into mainline, 
and stop maintaining the out of tree patcheset for new releases.  His last 
post on the subject (to the linux-tiny mailing list) was a year ago:
http://selenic.com/pipermail/linux-tiny/2006-March/000314.html

But what happened is that most of the abandoned patches stopped applying to 
new kernels yet still weren't available in mainline a year later, so Tim and 
Michael have stepped in to revive the -tiny tree.  (Tim talked about this a 
bit at the CELF BOF at OLS, which is more acronyms than should really show up 
immediately after one another in any confersation, FYI.)

So yay new tree.  Tried without it, didn't work.  Broken up to make merging 
easier, but mainline will probably never _fully_ catch up, any more than 
it'll catch up with any of the other special-interest development trees.  
Making -tiny an .hg tree would be really really nice, though... :)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

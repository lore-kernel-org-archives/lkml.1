Return-Path: <linux-kernel-owner+w=401wt.eu-S1765504AbXIUVPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765504AbXIUVPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763507AbXIUVPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 17:15:45 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38862
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763416AbXIUVPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 17:15:44 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Gross, Mark" <mark.gross@intel.com>
Subject: Re: Message codes (Re: [Announce] Linux-tiny project revival)
Date: Fri, 21 Sep 2007 16:15:39 -0500
User-Agent: KMail/1.9.6
Cc: "Oleg Verych" <olecom@flower.upol.cz>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Michael Opdenacker" <michael@free-electrons.com>,
       linux-tiny@selenic.com,
       "CE Linux Developers List" <celinux-dev@tree.celinuxforum.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
References: <46F1645D.9050406@am.sony.com> <E1IYWps-0006fQ-83@flower> <5389061B65D50446B1783B97DFDB392D07126ACB@orsmsx411.amr.corp.intel.com>
In-Reply-To: <5389061B65D50446B1783B97DFDB392D07126ACB@orsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211615.39898.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 September 2007 9:18:40 am Gross, Mark wrote:
> >-----Original Message-----
> >From: Oleg Verych [mailto:olecom@flower.upol.cz]
> >Sent: Thursday, September 20, 2007 5:58 PM
> >To: Gross, Mark
> >Cc: Rob Landley; Alexey Dobriyan; Michael Opdenacker; linux-
> >tiny@selenic.com; CE Linux Developers List; linux kernel
> >Subject: Message codes (Re: [Announce] Linux-tiny project revival)
> >
> >* Thu, 20 Sep 2007 15:15:47 -0700
> >* X-MimeOLE: Produced By Microsoft Exchange V6.5
> >[]
> >
> >>>*Shrug*.
> >>>
> >>>My problem is that switching off printk is the single biggest bloat
> >>
> >> cutter
> >>
> >>>in
> >>>the kernel, yet it makes the resulting system very hard to support.
>
> It
>
> >>>combines a big upside with a big downside, and I'd like something in
> >>>between.
> >>
> >> What about getting even more hard core?
> >>
> >> Use compiler tricks to remove ALL the static printk string from the
> >> kernel and replace the printk with something that outputs an decimal
> >> index followed by tuples, of zero to N, hex-strings on a single line.
> >
> >Not all, but critical info, that must exist in human-readable form of
> >course.
>
> I disagree.  For a production product the you want minimal information
> to reduce the communication bandwidth required between the remote
> customer and the support organization.
>
> In fact there is a good argument that you don't what the remote customer
> to know enough to start guessing.

Don't use Linux then.  Open source is a horrible fit for the way you think.

I'm sympathetic to "shrink the binary size" arguments.  I'm not really 
sympathic to "keep the customer in the dark intentionally" arguments, whether 
the justification is "because they're stupid", "to increase dependency on our 
support staff", or any other reason.

> >Seriously. When in the Windows there are only messages like:
> >
> >    "Error (Code:0x00002012)".
>
> Now it's been ~8 years since I did any serious windows work, but if I
> recall correctly ALL THE FRICKING TIME!!! When was the last time you've
> seen a bug check on windows?  This is about all you get.

I believe he was holding it up as a bad example, and definitely not something 
we want to emulate.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

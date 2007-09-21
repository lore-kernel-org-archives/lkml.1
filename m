Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbXIUAmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbXIUAmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 20:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbXIUAmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 20:42:05 -0400
Received: from barikada.upol.cz ([158.194.242.200]:33947 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbXIUAmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 20:42:04 -0400
To: "Gross, Mark" <mark.gross@intel.com>
Cc: "Rob Landley" <rob@landley.net>, "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Michael Opdenacker" <michael@free-electrons.com>,
       <linux-tiny@selenic.com>,
       "CE Linux Developers List" <celinux-dev@tree.celinuxforum.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
Subject: Message codes (Re: [Announce] Linux-tiny project revival)
In-Reply-To: <5389061B65D50446B1783B97DFDB392D07126574@orsmsx411.amr.corp.intel.com>
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net> <20070920195844.GA1805@martell.zuzino.mipt.ru> <200709201702.08126.rob@landley.net> <5389061B65D50446B1783B97DFDB392D07126574@orsmsx411.amr.corp.intel.com>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Fri, 21 Sep 2007 02:57:36 +0200
Message-Id: <E1IYWps-0006fQ-83@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thu, 20 Sep 2007 15:15:47 -0700
* X-MimeOLE: Produced By Microsoft Exchange V6.5
[]
>>*Shrug*.
>>
>>My problem is that switching off printk is the single biggest bloat
> cutter
>>in
>>the kernel, yet it makes the resulting system very hard to support.  It
>>combines a big upside with a big downside, and I'd like something in
>>between.
>
> What about getting even more hard core? 
>
> Use compiler tricks to remove ALL the static printk string from the
> kernel and replace the printk with something that outputs an decimal
> index followed by tuples, of zero to N, hex-strings on a single line.

Not all, but critical info, that must exist in human-readable form of
course.

> Then have the syslogd or some other utility take this cryptic output and
> convolve it with a table (created at compile time) to re-create what
> would have been dumped to the sys-log ring buffer.  This way you strip
> out most of the static text from the kernel and yet can still re-create
> the kernlog output.
>
> At least as a post processing operation....

Sure, but a little problem is, that many kernel developers do C (mostly)
and Perl (occasionally), i.e. very few do non-trivial userspace (even
userspace do too much C and Perl sometimes [:
<http://thread.gmane.org/gmane.comp.lib.glibc.alpha/12739>)

> Is this an old idea?  I'm guessing this has been at least proposed
> before....

Seriously. When in the Windows there are only messages like:

    "Error (Code:0x00002012)".

In the Linux... well, embedded targets, this can be turned in a very
efficient thing by means of userspace. On other setups this can be nice
and pleasant one, with yet another L10N project, recently promoted by
README translations. But,,, see problem above.
____

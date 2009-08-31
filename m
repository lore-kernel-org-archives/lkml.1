Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbZHaTfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbZHaTfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbZHaTfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:35:39 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33878 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbZHaTfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:35:38 -0400
Date: Mon, 31 Aug 2009 15:33:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: memleaks, acpi + ext4 + tty
Message-ID: <20090831193345.GG5631@tuxdriver.com>
References: <43e72e890908272225w79ec5bf6kc7ef1160e5a088ae@mail.gmail.com> <tnxtyzr7vcl.fsf@pc1117.cambridge.arm.com> <43e72e890908280952j410293fbm47b4b9d566e26c14@mail.gmail.com> <43e72e890908281450k78cc1a2fmd4fd033ae0f4176f@mail.gmail.com> <43e72e890908281509o44930348w581b865107ea3e98@mail.gmail.com> <43e72e890908310123w5d361ed5tff58a7663044bdcd@mail.gmail.com> <43e72e890908311050s320d0ceen312a0d3d9e4fbc76@mail.gmail.com> <43e72e890908311137k78ac439bs4edf376d07343a32@mail.gmail.com> <43e72e890908311230u28b0642ep7a6bfd9dab82318a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890908311230u28b0642ep7a6bfd9dab82318a@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 12:30:15PM -0700, Luis R. Rodriguez wrote:
> On Mon, Aug 31, 2009 at 11:37 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:

> > OK I tried this, I even 'rm -rf * ; git checkout -f' and ..
> > merge-2009-08-28 tag yields the same issues, long lag upon bootup with
> > some kmemleaks I cannot even get to check. So somehow something is
> > different between merge-2009-08-28 and Linus' rc8. This is just
> > bizarre so to be even safer I'm just going to do a fresh git clone on
> > wireless-testing.
> 
> Hey John so I tested wireless-testing on the merge-2009-08-28 tag on a
> fresh git pull and verified this is indeed busted for me. Although I
> had tried hpa's linux-2.6-allstable on HEAD just to be sure I am now
> building Linus' tree from a fresh git clone on the v2.6.31-rc8 tag
> just to be double check this was indeed not a 2.6.31-rc8 issue but
> instead *something* on wireless-testing. What that something is is
> unclear to me still, I guess after all these tests I'll run a manual
> diff as git doesn't seem to be picking anything up.

As you determined, there is no difference between merge-2009-08-28
and v2.6.31-rc8.  If one works and the other doesn't, then the main
thing not working will be git...

What is linux-2.6-allstable?  My guess is that the culprit is between
v2.6.31-rc8 and whatever is at the head of linux-2.6-allstable.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

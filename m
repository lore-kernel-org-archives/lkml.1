Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbZHaUAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbZHaUAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 16:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbZHaUAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 16:00:24 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56480 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbZHaUAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 16:00:23 -0400
Date: Mon, 31 Aug 2009 15:47:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: memleaks, acpi + ext4 + tty
Message-ID: <20090831194753.GH5631@tuxdriver.com>
References: <tnxtyzr7vcl.fsf@pc1117.cambridge.arm.com> <43e72e890908280952j410293fbm47b4b9d566e26c14@mail.gmail.com> <43e72e890908281450k78cc1a2fmd4fd033ae0f4176f@mail.gmail.com> <43e72e890908281509o44930348w581b865107ea3e98@mail.gmail.com> <43e72e890908310123w5d361ed5tff58a7663044bdcd@mail.gmail.com> <43e72e890908311050s320d0ceen312a0d3d9e4fbc76@mail.gmail.com> <43e72e890908311137k78ac439bs4edf376d07343a32@mail.gmail.com> <43e72e890908311230u28b0642ep7a6bfd9dab82318a@mail.gmail.com> <20090831193345.GG5631@tuxdriver.com> <43e72e890908311243u50b9323fveda9feaaa4d8efdb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890908311243u50b9323fveda9feaaa4d8efdb@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 12:43:01PM -0700, Luis R. Rodriguez wrote:
> On Mon, Aug 31, 2009 at 12:33 PM, John W.
> Linville<linville@tuxdriver.com> wrote:

> > My guess is that the culprit is between
> > v2.6.31-rc8 and whatever is at the head of linux-2.6-allstable.
> 
> But the issue is *not* in linux-2.6-allstable, it is only present on
> wireless-testing, and I went as far back as merge-2009-08-28. I was
> using whatever tag was available prior to you moving to rc8, and that
> worked.

OK, then I can only guess that something went wrong in your bisection
(e.g. dirty build, something not marked properly, etc).  That, or
different .config files between your linux-2.6-allstable build and
the merge-2009-08-28 build of wireless-testing?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

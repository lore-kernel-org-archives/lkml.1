Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbYJISep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbYJISep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbYJISee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:34:34 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:8177 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbYJISee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:34:34 -0400
X-IronPort-AV: E=Sophos;i="4.33,384,1220241600"; 
   d="scan'208";a="60846341"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: RFC - size tool for kernel build system
Date: Thu, 9 Oct 2008 14:34:35 -0400
User-Agent: KMail/1.9.5
Cc: "Tim Bird" <tim.bird@am.sony.com>,
       "linux-embedded" <linux-embedded@vger.kernel.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
References: <48EBD268.50208@am.sony.com> <20081009152151.GB17013@cs181140183.pp.htv.fi>
In-Reply-To: <20081009152151.GB17013@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810091434.35783.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 09 Oct 2008 18:34:32.0440 (UTC) FILETIME=[AC08CF80:01C92A3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 9 Oct 2008 11:21, Adrian Bunk pondered:
> On Tue, Oct 07, 2008 at 02:19:36PM -0700, Tim Bird wrote:
> > I've been thinking about a tool that might be useful
> > to track kernel size changes.  I'm posting this
> > Request For Comments to get feedback, and determine
> > if this is something that would be worthwhile to
> > pursue.
> > 
> > What I envision is some new kernel build targets, specifically
> > related to gathering size information and generating a size
> > comparison report.  Some small helper scripts would be written
> > to gather the necessary information, and generate the report.
> >...
> > Any comments?
> 
> The building blocks that would be useful are IMHO:
> - a make target that generates a report for one kernel
>   (like the checkstack or export_report targets)

and the report includes sizes of more than just the text section? Which is my 
biggest pet peeve with bloat-o-meter today, since it uses nm, not readelf - 
and saving data is just as important as saving instruction.

> - a script that compares two such reports and outputs the
>   size differences
> 
> That's also easy to do, and if that's what's wanted I can send a patch 
> that does it.
> 
> Everything else is IMHO overdesigned.

I understand the desire though - make it easier to compare two setups.

capturing a make target into a file, (make size_report > config1.size) and 
running a compare on two outputs seems like a more "standard" way of doing 
things...

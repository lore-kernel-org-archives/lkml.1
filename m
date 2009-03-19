Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbZCSMbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbZCSMbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 08:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbZCSMbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 08:31:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39701 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbZCSMbP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 08:31:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Li Yang <leoli@freescale.com>
Subject: Re: nonboot cpu on SMP suspend
Date: Thu, 19 Mar 2009 13:30:58 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: chen gong <gong.chen@linux.intel.com>, linux-kernel@vger.kernel.org
References: <2a27d3730903172325w16ec329cp872ec35d100f6506@mail.gmail.com> <49C1EE7D.5070507@linux.intel.com> <2a27d3730903190018h1a0f5b6asf5cf2002fe3504fb@mail.gmail.com>
In-Reply-To: <2a27d3730903190018h1a0f5b6asf5cf2002fe3504fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903191330.59573.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 March 2009, Li Yang wrote:
> On Thu, Mar 19, 2009 at 3:04 PM, chen gong <gong.chen@linux.intel.com> wrote:
> > Rafael J. Wysocki 写道:
> >>
> >> On Wednesday 18 March 2009, Li Yang wrote:
> >>>
> >>> Hi all,
> >>>
> >>> I'm curious why we need to un-plug all the nonboot cpus before suspend
> >>> and start them all over again after the suspend(ACPI sleep)?  I mean
> >>> if we can bring the booting cpu back to the exact state as before
> >>> suspend, why can't we just do the same for non-booting cpus?  And that
> >>> will be much faster.  Any thought?  Thanks.
> >>
> >> Because we need to enter the BIOS with one CPU on-line only.
> >>
> > You mean only one CPU can be supported by BIOS when suspend/resume ?
> 
> If so, is it a defect of x86 BIOS?  And is it true that for other
> architectures without a BIOS there won't be such a limitation if the
> boot code is sane?  Thanks

I think that is a limitation of x86 BIOS and I don't know enough about the
other architectures to comment.

Thanks,
Rafael


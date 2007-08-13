Return-Path: <linux-kernel-owner+w=401wt.eu-S943606AbXHMUZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943606AbXHMUZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbXHMUYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:24:54 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:5557 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbXHMUYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:24:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZSLOdmndrPx1olNKXdycoxHGEp41pTueXL0fbr/lHiBa+vFc0Sg7Z6Q+sAIa+jmHcqAyR0JfxXg1FPo57Ev+yI8eVST3vKHHhV9iOeRu0HBOHTfvDgb3ve2uGbnvBSIra7R6fQueobTUJMWoGoXdjBB7b8ty8yBlVJnaGBC7jaw=
Message-ID: <6bffcb0e0708131324x29211ef5sd5154d44f0c2e79f@mail.gmail.com>
Date: Mon, 13 Aug 2007 22:24:52 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [1/2] 2.6.23-rc3: known regressions with patches
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Vitaly Bordug" <vitb@kernel.crashing.org>,
       "Dan Merillat" <dan.merillat@gmail.com>,
       "Paolo Ornati" <ornati@fastwebnet.it>,
       "Rusty Russell" <rusty@rustcorp.com.au>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, "Jeff Garzik" <jeff@garzik.org>,
       "Trond Myklebust" <Trond.Myklebust@netapp.com>
In-Reply-To: <20070813184204.GA6071@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46C09C1A.7050706@googlemail.com>
	 <20070813184204.GA6071@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/07, Andi Kleen <andi@firstfloor.org> wrote:
> > Unclassified
> >
> > Subject         : reset during bootup - 2.6.23-rc2 (git d23cf676)
>
> This is already fixed in mainline

commit b8d3f2448b8f4ba24f301e23585547ba1acc1f04

>
> There is a real regression with failing builds on some old binutils on
> x86-64 know, but I don't know how to fix it.

Did you mean this?

Subject         : /usr/bin/ld: section .text [ffffffffff700500 ->
ffffffffff7007e3] overlaps section .gnu.version_d [ffffffffff7004d8 ->
ffffffffff70050f]
References      : http://lkml.org/lkml/2007/7/22/239
Last known good : ?
Submitter       : Andre Noll <maan@systemlinux.org>
Caused-By       : ?
Handled-By      : Andi Kleen <ak@suse.de>
Status          : problem is being debugged

>
> -Andi
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/

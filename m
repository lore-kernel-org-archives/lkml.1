Return-Path: <linux-kernel-owner+w=401wt.eu-S1765820AbXHHPlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765820AbXHHPlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXHHPl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:41:29 -0400
Received: from smtp27.orange.fr ([80.12.242.96]:59288 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbXHHPl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:41:28 -0400
X-ME-UUID: 20070808154126818.C7C6A1C0009B@mwinf2718.orange.fr
From: paul <paul.pinault@disk91.com>
Reply-To: paul.pinault@disk91.com
To: "Wander Winkelhorst" <w.winkelhorst@gmail.com>
Subject: Re: Data corruption
Date: Wed, 8 Aug 2007 17:41:24 +0200
User-Agent: KMail/1.9.5
Cc: "Chris Snook" <csnook@redhat.com>, linux-kernel@vger.kernel.org
References: <200708072007.27343.paul.pinault@disk91.com> <200708080831.10141.paul.pinault@disk91.com> <5699f8f00708080744m42eebdeaqdc42daffec1b7d8d@mail.gmail.com>
In-Reply-To: <5699f8f00708080744m42eebdeaqdc42daffec1b7d8d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708081741.25320.paul.pinault@disk91.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 8 août 2007 16:44, Wander Winkelhorst a écrit :
> On 8/8/07, paul <paul.pinault@disk91.com> wrote:
> > Hi, thank you for your answer, actually I removed 2Gb of physical memory
> > and
> > the problem gone away .. but my system needs 4Gb.
> >
> > I reproduce it under Xen and without xen (on a standard kernel) I can't
> > tell
> > you how mutch difference I have betwwen files, regarding a 4 month system
> > running on these condition, I think the number of errors are rare but
> > existing, during my tests with 100M files I did not get a lot of error,
> > so we
> > can assume 2 or 3 bytes in error in 300M files... (expectation)
> >
> > I try to avaoid it by disabeling memory relocation on my MB ... in that
> > case
> > the system only detect 2.8G (and Linux too), The probem still there.
>
> Do you have the latest BIOS of your motherboard?
> The latest version is 0901 and that version fixes:
>
> "Fix memory remapping function is not working properly issue."
>
> Download from:
> http://support.asus.com/download/download_item.aspx?product=1&model=P5B-VM&
>SLanguage=en-us
>
> Hope that helps,
>
> Wander.

Yes I had... I expected a solution here ...  but not !

Just changed my mother board for a P5N-E... it works correctly with 4GB but I 
had also to change 2 DDR2 not recognized by this new system ... My opinion 
memory is not the root cause as long memory test did not detect errors on the 
initial system...

Problem is closed for me as I changed my hardware .. but if someone could 
confirm the issue on an other and same system ... it would be interresting as 
this problem apeared for me when I add +2GB on my system, causing some lost 
of data on my server and numerous crashed ... I mean the impact on data could 
be hudge.



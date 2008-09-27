Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbYI0Rxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbYI0Rxx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbYI0Rwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:52:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39282 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757130AbYI0Rwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:52:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #11237] corrupt PMD after resume
Date: Sat, 27 Sep 2008 19:58:31 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Hugh Dickins <hugh@veritas.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik> <V8eU91268VO.A.L5.C_m3IB@albercik> <20080927174439.GD26047@elte.hu>
In-Reply-To: <20080927174439.GD26047@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809271958.32326.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 27 of September 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report of 
> > recent regressions.
> > 
> > The following bug entry is on the current list of known regressions 
> > from 2.6.26.  Please verify if it still should be listed and let me 
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11237
> > Subject		: corrupt PMD after resume
> > Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> > Date		: 2008-08-02 9:51 (57 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121767073424952&w=4
> > Handled-By	: Hugh Dickins <hugh@veritas.com>
> > 		  Jeremy Fitzhardinge <jeremy@goop.org>
> > Patch		: http://marc.info/?l=linux-kernel&m=122001615314700&w=2
> 
> actually, it's now believed that this is a BIOS problem that affects all 
> Linux versions. The aspect of v2.6.27 is that it happens to put kernel 
> pagetables into the area that gets corrupted by the BIOS - and users 
> notice that.
> 
> i.e. it's not a regression - unless i'm missing something.

OK, I dropped it from the list.

Thanks,
Rafael

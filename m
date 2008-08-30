Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYH3WBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYH3WBR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 18:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbYH3WBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 18:01:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58559 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbYH3WBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 18:01:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [Bug #11237] corrupt PMD after resume
Date: Sun, 31 Aug 2008 00:04:27 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik> <N8SeMoDzuxC.A.kUG.jkbuIB@albercik> <48B9C052.8090404@tuffmail.co.uk>
In-Reply-To: <48B9C052.8090404@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808310004.28470.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 30 of August 2008, Alan Jenkins wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11237
> > Subject		: corrupt PMD after resume
> > Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> > Date		: 2008-08-02 9:51 (29 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121767073424952&w=4
> > Handled-By	: Hugh Dickins <hugh@veritas.com>
> > 		  Jeremy Fitzhardinge <jeremy@goop.org>
> >
> >   
> 
> This has been isolated (to disparate buggy BIOSes), patches written and
> tested.  It's more policy decisions now; mainly whether the workaround
> (which wastes 64k) should be applied by default.  So I think you should add
> 
> Patch                   :
> http://marc.info/?l=linux-kernel&m=122001615314700&w=2

Done.

Thanks,
Rafael

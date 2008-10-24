Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYJXTz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYJXTz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYJXTzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:55:46 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33295 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607AbYJXTzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:55:45 -0400
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDEV list <netdev@vger.kernel.org>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: Re: e1000e fails after several S3 resumes (2.6.26 Debian, TP T60) 
In-Reply-To: Your message of "Fri, 24 Oct 2008 09:22:58 PDT."
             <F169D4F5E1F1974DBFAFABF47F60C10A069DFFA0@orsmsx507.amr.corp.intel.com> (sfid-20081024_142044_698098_A035A635) 
X-Mailer: MH-E 8.1; nmh 1.2; GNU Emacs 22.2.1
Date: Fri, 24 Oct 2008 15:54:57 -0400
From: Sanjoy Mahajan <sanjoy@MIT.EDU>
Message-Id: <E1KtSkL-0001xo-QM@approx.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brandeburg, Jesse <jesse.brandeburg@intel.com> wrote:

> > I say 'upgrade' because now S3 sleep and wakeup often take 60
> > seconds.  I've also noticed ACPI errors in the 'dmesg'.  Once I have
> > something reproducible I'll file a bugzilla report.
>
> ick, it would be nice if the system vendors actually tested their acpi
> implementations on multiple OSes.

They do: XP, Vista, NT, ...  Are there any other OS's?!

Good news for 2.6.27.3: With the latest stable kernel, the
suspend/resume is quick again, and the ACPI dmesg errors are gone!

So I'll keep running it and wait for the e1000e problem to return (or
vanish).  I'll hurry it along by doing suspend/resume/dhcp lots of
times.

-Sanjoy

`Until lions have their historians, tales of the hunt shall always
 glorify the hunters.'  --African Proverb

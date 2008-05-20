Return-Path: <linux-kernel-owner+w=401wt.eu-S1762703AbYETIQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762703AbYETIQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758188AbYETIQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:16:21 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:40438 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172AbYETIQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:16:18 -0400
Date: Tue, 20 May 2008 10:16:17 +0200
To: Romano Giannetti <romanol@upcomillas.es>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc2 hosed X?
Message-ID: <20080520081617.GA14141@gamma.logic.tuwien.ac.at>
References: <20080513103828.GA8288@gamma.logic.tuwien.ac.at> <1211269474.8773.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211269474.8773.10.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 20 Mai 2008, Romano Giannetti wrote:
> > Is that something known, are is there some patch to revert/test?
> > 
> 
> Maybe related to: http://bugzilla.kernel.org/show_bug.cgi?id=10620 ?

I had the very same problems like you and I had to apply two patches:
(see http://bugzilla.kernel.org/show_bug.cgi?id=10709)

The one is included in -rc3, that was solved by applying 
	http://lkml.org/lkml/2008/5/13/188

the former was solved by using the vblank reverse patch given in the
above bug, or directly here:
	http://marc.info/?l=linux-kernel&m=121074889124387&w=4

Try -rc3 plus this patch, it is now working here.  In bocca al lupo!

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
LUBCROY (n.)
The telltale little lump in the top of your swimming trunks which
tells you you are going to have to spend half an hour with a safety
pin trying to pull the drawstring out again.
			--- Douglas Adams, The Meaning of Liff

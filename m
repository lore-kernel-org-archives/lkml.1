Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZBQPPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZBQPPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZBQPPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:15:07 -0500
Received: from mail-ausfall.charite.de ([193.175.70.131]:35076 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZBQPPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:15:06 -0500
Date: Tue, 17 Feb 2009 16:15:02 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: Re: sync-Regression in 2.6.28.2?
Message-ID: <20090217151502.GC16681@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20090127093533.GB7037@charite.de> <20090209134958.GP27548@charite.de> <20090215134235.GB15398@charite.de> <200902171517.23980.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200902171517.23980.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Piggin <nickpiggin@yahoo.com.au>:

> > Still there in 2.6.28.5 :(
> 
> I believe it is basically a deadlock in ext4 due to the cyclic writeback
> change.

That could be. It happens during time of big write activity here.
 
> http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=2acf2c261b823d9d9ed954f348b97620297a36b5
> 
> ext4 guys, is this correct? Is there a minimal fix that can be made for
> .stable kernels?
> 

-- 
Ralf Hildebrandt                                Ralf.Hildebrandt@charite.de
Charite - Universitätsmedizin Berlin            Tel.  +49 (0)30-450 570-155
Geschäftsbereich IT | Abt. Netzwerk             Fax.  +49 (0)30-450 570-962
Hindenburgdamm 30 | 12200 Berlin

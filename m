Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbXIZDil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbXIZDil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbXIZDia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:38:30 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42012 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbXIZDi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:38:29 -0400
Date: Tue, 25 Sep 2007 21:38:27 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jeff Garzik <jeff@garzik.org>
Cc: FUJITA Tomonori <tomof@acm.org>, James.Bottomley@SteelEye.com,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: queued patches for SCSI for 2.6.24
Message-ID: <20070926033827.GB3899@parisc-linux.org>
References: <1190768402.8707.20.camel@localhost.localdomain> <20070925065233Q.tomof@acm.org> <1190770955.8707.23.camel@localhost.localdomain> <20070925073735U.tomof@acm.org> <46F9C5ED.6050505@garzik.org> <20070926025608.GA3899@parisc-linux.org> <46F9D328.4030801@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F9D328.4030801@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 11:34:00PM -0400, Jeff Garzik wrote:
> Well, sure, the driver is the owner of that memory.
> 
> We're talking about common code.
> 
> If everybody agrees SHT is R/W in the core, Fujita-san's patch is fine.

Oh ... harder to find, but scsi_module.c does that, as does
scsi_register/scsi_unregister.  OK, those are legacy, but they still
exist today.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

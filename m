Return-Path: <linux-kernel-owner+w=401wt.eu-S933413AbYF3WJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbYF3WJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762913AbYF3WJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:09:43 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:59257 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762841AbYF3WJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:09:43 -0400
Date: Mon, 30 Jun 2008 22:09:39 +0000
From: Sean Young <sean@mess.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       "H. Anvin" <hpa@zytor.com>
Subject: Re: Regression: boot failure on AMD Elan TS-5500
Message-ID: <20080630220939.GA58260@atlantis.8hz.com>
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4869558A.9020907@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 02:52:10PM -0700, Jeremy Fitzhardinge wrote:
> It's a bit odd that the boot loader neglected to set up ds properly, but 
> changing the testb line to
> 
> 	testb $(1<<6), %cs:BP_loadflags(%esi)
> 
> should work.  (Or perhaps a %ss: override would be better?)

Yup, it does (%cs: prefix).

> I'm assuming that the GDT setup isn't completely mad and that the 
> segments have the same base at least.

Where do I go from here?

Thanks
Sean

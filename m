Return-Path: <linux-kernel-owner+w=401wt.eu-S1761267AbYGQWp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761267AbYGQWp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYGQWps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:45:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbYGQWpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:45:47 -0400
Date: Thu, 17 Jul 2008 15:42:21 -0700
From: Greg KH <gregkh@suse.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Ingo Molnar <mingo@elte.hu>, Linux I2C <i2c@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [crash, bisected] I2C, kobject (ffff81003e8c4160): tried to
	init  an initialized object (was: Re: [GIT PULL] i2c updates for
	2.6.27, round 1)
Message-ID: <20080717224221.GB28108@suse.de>
References: <20080714224945.629446fa@hyperion.delvare> <20080716082352.GA30483@elte.hu> <20080716110702.3ca61eb2@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716110702.3ca61eb2@hyperion.delvare>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 11:07:02AM +0200, Jean Delvare wrote:
> > btw., Greg, the kobject debugging check and output is really nice, 
> > informative and useful! It likely pinpoints the real bug here.
> 
> Is this something new in 2.6.26-gitX? I want to know if the bug is
> something new or if it could be already present in 2.6.26 and earlier
> kernels and went unnoticed so far.

It is in 2.6.26 as I haven't merged any patches with Linus yet, portions
of it might be in older kernels, but not in the same type of format.

thanks,

greg k-h

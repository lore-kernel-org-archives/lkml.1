Return-Path: <linux-kernel-owner+w=401wt.eu-S1760606AbYBCPKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606AbYBCPKB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 10:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbYBCPJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 10:09:52 -0500
Received: from smtp-100-sunday.noc.nerim.net ([62.4.17.100]:1807 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752092AbYBCPJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 10:09:52 -0500
Date: Sun, 3 Feb 2008 16:09:48 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux I2C" <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] i2c updates for 2.6.25
Message-ID: <20080203160948.4182200c@hyperion.delvare>
In-Reply-To: <9e4733910801280620t16ceb391vcc8e10ba6bbea183@mail.gmail.com>
References: <20080127182741.62bfe92a@hyperion.delvare>
 <9e4733910801270936q7affdee3o3518c2265acaf61d@mail.gmail.com>
 <20080128104348.0f6925f6@hyperion.delvare>
 <9e4733910801280620t16ceb391vcc8e10ba6bbea183@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 09:20:13 -0500, Jon Smirl wrote:
> On 1/28/08, Jean Delvare <khali@linux-fr.org> wrote:
> > The status is that I want to give people some time to comment on my
> > modalias patches before I merge them. I also didn't have the time to
> > look into the latest patches you sent yet, and I'd rather merge
> > everything at once. So the merge window for this is rather 2.6.26.
> 
> Delaying these until 2.6.26 which won't be final until 2009 forces us
> to ship boxes using a private kernel. These patches have been around
> since November. Does it really take over a year to get these changes
> in?

It can even take forever when people piss me off.

This patch set affects 5 different subsystems and several
dozen drivers. All these drivers have been (ab)using the previous
and current I2C device naming and device/driver matching logic in
different ways, and have different expectations and needs. I'm not
changing this now to break it again next month when other kernel
developers will complain that the new model doesn't work for them.

-- 
Jean Delvare

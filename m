Return-Path: <linux-kernel-owner+w=401wt.eu-S933162AbXGLSm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162AbXGLSm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 14:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbXGLSmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 14:42:49 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:57413 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbXGLSmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 14:42:49 -0400
Date: Thu, 12 Jul 2007 11:42:47 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Jeff Garzik <jeff@garzik.org>
cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       dave@thedillows.org
Subject: Re: [RFT][PATCH v7] sata_mv: convert to new EH
In-Reply-To: <46960225.5000502@garzik.org>
Message-ID: <Pine.LNX.4.64.0707121140560.29365@twinlark.arctic.org>
References: <20070711200538.GA7374@havoc.gtf.org>
 <Pine.LNX.4.64.0707120212210.25837@twinlark.arctic.org> <46960225.5000502@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Jeff Garzik wrote:

> dean gaudet wrote:
> > oh very nice... no warnings on boot, and no warnings while i "dd if=/dev/sdX
> > of=/dev/null" and i'm seeing 74MB/s+ from each disk on this simple read
> > test.
> > 
> > for lack of a better test i started an untar/diff stress test on the
> > disks... we'll see how it goes.  (it's based on doug ledford's memtest.sh)
> 
> Thanks for the testing.  Looks like we might have hit on something good...

yep this does look good.  no problems overnight in the untar/diff/rm 
workload.  if you've got any other workload you'd like me to throw at it, 
let me know.  i might be able to scare up a disk or two with errors to 
check error handling.

i tested hotplug just for kicks... no luck there :)  but then you didn't 
say that would work yet.

thanks!
-dean

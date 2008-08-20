Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbYHTVSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbYHTVSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYHTVSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:18:15 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48587 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423AbYHTVSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:18:14 -0400
Subject: Re: new driver staged in linux1394-2.6.git
From: David Moore <dcm@MIT.EDU>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, v4l-dvb-maintainer@linuxtv.org,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <48AC8167.1020302@s5r6.in-berlin.de>
References: <tkrat.51b6249bb700fa85@s5r6.in-berlin.de>
	 <20080820201106.GC10526@kroah.com>  <48AC8167.1020302@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 14:16:52 -0700
Message-Id: <1219267012.26135.14.camel@dmoore.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 22:41 +0200, Stefan Richter wrote:
> Greg KH wrote:
> > This assumes that it will not be dropped by you :)
> 
> I'll carry it until mainline merge, unless bigger subsystem changes 
> happen on the v4l-dbv front that make it necessary to move it to their repo.

If I understand correctly, this driver is based on the legacy ieee1394
subsystem.  I'm curious, is there a plan to migrate it to juju, where
presumably it could be a lot cleaner and might not even have to live in
the kernel at all (except for the need for some sort of dvb loopback
device which might not yet exist)?

-David


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbYHIWCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbYHIWCV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 18:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYHIWB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 18:01:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34132 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbYHIWB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 18:01:57 -0400
Date: Sat, 9 Aug 2008 23:01:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bruno Pr?mont <bonbons@linux-vserver.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [2.6.27-rc2-git4] Kernel panic on VIA Ester+VIA CX700
Message-ID: <20080809220154.GO28946@ZenIV.linux.org.uk>
References: <20080809225153.2fdb23a8@neptune.home> <200808100000.25402.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808100000.25402.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 12:00:24AM +0200, Rafael J. Wysocki wrote:
> On Saturday, 9 of August 2008, Bruno Pr?mont wrote:
> > Hi,
> 
> Hi,
> 
> > Trying out 2.6.27-rc2-git4 on a VIA Ester + CX700 based system I
> > experience the following panic using a config obtained with make
> > oldconfig from working 2.6.26 config.
> > 
> > Looking at the traces and when it happens it looks like it could be
> > libATA or SCSI related...
> > 
> > 
> > Note: the kernel is patched with viafb patches sent yesterday ([y]) and
> > squashfs (<m>)
> 
> Could you retest without these two, please?

There'a another fun candidate: lazy allocation of fpu state.  Do you have
padlock-aes/padlock-sha/via-rng in use?

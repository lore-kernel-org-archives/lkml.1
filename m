Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYKBNPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYKBNPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 08:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYKBNPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 08:15:21 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60438 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbYKBNPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 08:15:21 -0500
Message-ID: <490DA7E3.8040802@garzik.org>
Date: Sun, 02 Nov 2008 08:15:15 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Subbu Seetharaman <subbus@serverengines.com>, Greg KH <greg@kroah.com>
CC: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] benet: BladeEngine 10Gb NIC driver
References: <20080916090021.c4a58c42@mailhost.serverengines.com>
In-Reply-To: <20080916090021.c4a58c42@mailhost.serverengines.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subbu Seetharaman wrote:
> Jeff,
> 
> It is more than two months since the benet driver patch was made available as a single file as suggeted by you :
> 
> ftp://ftp.serverengines.com/0001.benet.patch
> 
> I have not seen this applied.  Is there any reason for not applying this  patch ?  Do you want a patch against the latest git tree ?

The overall consensus at this year's Linux Kernel Summit was that this 
driver still needs a lot of cleanup, so I'm gonna try an experiment and 
stick this in the staging tree (currently jgarzik/netdev-2.6.git#benet).

Greg, do I need to do anything beyond simply putting it into the 
directory?  Do I need to add some code to taint, perhaps?

	Jeff



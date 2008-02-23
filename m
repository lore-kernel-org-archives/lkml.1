Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbYBWXcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbYBWXcf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 18:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759641AbYBWXbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 18:31:21 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58736 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756994AbYBWXbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 18:31:19 -0500
Message-ID: <47C0ACC1.1050306@garzik.org>
Date: Sat, 23 Feb 2008 18:31:13 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] scsi fixes for 2.6.25-rc2
References: <1203779614.3139.4.camel@localhost.localdomain> <20080223230126.GA23265@lixom.net>
In-Reply-To: <20080223230126.GA23265@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> Hi,
> 
> On Sat, Feb 23, 2008 at 09:13:33AM -0600, James Bottomley wrote:
> 
>> Jeff Garzik (1):
>>       mvsas: Add Marvell 6440 SAS/SATA driver
> [...]
>>  drivers/scsi/mvsas.c                | 2981 ++++++++++++++++++++++++++++++++++++
> 
> I just noticed that the file permissions on that file are 755 in current
> git, that was probably not intentional?

Definitely not intentional.  They were 0644 in the original changeset 
(the one from me you highlighted), then the second changeset updating 
mvsas somehow changed the perms.

	Jeff




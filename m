Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbYCURcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbYCURcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYCURcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:32:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753185AbYCURcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:32:19 -0400
Date: Fri, 21 Mar 2008 10:31:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Subject: Re: [SCSI] fix media change events for polled devices
In-Reply-To: <47E3EC67.4050404@garzik.org>
Message-ID: <alpine.LFD.1.00.0803211031010.3020@woody.linux-foundation.org>
References: <200803211559.m2LFxPi6017869@hera.kernel.org> <47E3EC67.4050404@garzik.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Mar 2008, Jeff Garzik wrote:
> 
> And that is the fix -- initialize supported_events according to sr/sd's needs,
> and revert this change (4d1566ed2100d074ccc654e5cf2e44cdea3a01d0) as obviously
> broken.

Patches, please? I can do the revert, but the patch to supported_events 
and the testing, please?

		Linus

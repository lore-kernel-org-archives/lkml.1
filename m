Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbYCELeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbYCELeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 06:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbYCELeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 06:34:00 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:34387 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbYCELd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 06:33:59 -0500
Message-ID: <47CE851E.4000401@garzik.org>
Date: Wed, 05 Mar 2008 06:33:50 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Greg Ungerer <gerg@snapgear.com>
CC: torvalds@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [M68KNOMMU]: fix fec driver interrupt races
References: <200803040652.m246q1SH012800@goober>
In-Reply-To: <200803040652.m246q1SH012800@goober>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Ungerer wrote:
> The FEC driver has a common interrupt handler for all interrupt event
> types. It is raised on a number of distinct interrupt vectors.
> This handler can't be re-entered while processing an interrupt, so
> make sure all requested vectors are flagged as IRQF_DISABLED.
> 
> Signed-off-by: Greg Ungerer <gerg@uclinux.org>

NAK -- add spinlocks to your interrupt handling like you are supposed to



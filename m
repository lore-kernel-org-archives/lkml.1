Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYGGSCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYGGSCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756539AbYGGSCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:02:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34785 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbYGGSCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:02:06 -0400
Message-ID: <48725A16.6010307@zytor.com>
Date: Mon, 07 Jul 2008 11:01:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christian Ehrhardt <lk@c--e.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Boot failures on Qemu due to P6_NOPS
References: <20080707172334.GH1009@lisa.in-ulm.de>
In-Reply-To: <20080707172334.GH1009@lisa.in-ulm.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Ehrhardt wrote:
> Hi,
> 
> this might well be a bug in Qemu but even then, it would be nice if the
> linux kernel could do a work around.
> 

It is a Qemu bug.  Microsoft Virtual Server 2005 have it too.

One *major* problems with virtualizers is that they uniformly use an 
existing CPU identifier, even though they might have their own sets of 
bugs.  This makes it much harder to work around bugs in them.

	-hpa

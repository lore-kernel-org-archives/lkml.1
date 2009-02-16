Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbZBPSwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbZBPSwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 13:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbZBPSwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 13:52:41 -0500
Received: from cpsmtpo-eml01.KPNXCHANGE.COM ([213.75.38.150]:40175 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbZBPSwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 13:52:40 -0500
From: Frans Pop <elendil@planet.nl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: cpuinfo shows wrong MHz value
Date: Mon, 16 Feb 2009 19:52:37 +0100
User-Agent: KMail/1.9.9
Cc: trenn@suse.de, linux-kernel@vger.kernel.org
References: <200902142217.51655.jplatte@naasa.net> <loom.20090216T141158-818@post.gmane.org> <20090216165008.GA8249@srcf.ucam.org> <200902161913.16021.trenn@suse.de> <200902161913.16021.trenn@suse.de> <20090216181936.GA9831@srcf.ucam.org>
In-reply-To: <20090216181936.GA9831@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902161952.38122.elendil@planet.nl>
X-OriginalArrivalTime: 16 Feb 2009 18:52:38.0577 (UTC) FILETIME=[BD1FAA10:01C99067]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Mon, Feb 16, 2009 at 07:13:15PM +0100, Thomas Renninger wrote:
>> AFAIK p4-clockmode is still not synchronized with ACPI throttling?
> 
> It ought to work fine with any systems using MSR-based throttling.

So what's your take on this particular bug report then Matthew? Is this a 
regression that should be tracked down and fixed, or is this a case where 
the user should just not be using the module?

Having a module that loads happily but completely screws up the reported 
cpu frequency in /proc/cpuinfo seems suboptimal.

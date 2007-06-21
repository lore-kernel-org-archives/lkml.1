Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbXFUJAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbXFUJAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 05:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXFUI7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 04:59:53 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:44685 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbXFUI7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 04:59:52 -0400
Message-ID: <467A3DF8.2080008@dgreaves.com>
Date: Thu, 21 Jun 2007 09:59:36 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: david@lang.hm
Cc: David Chinner <dgc@sgi.com>, Neil Brown <neilb@suse.de>,
       Avi Kivity <avi@argo.co.il>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: limits on raid
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <467273AB.9010202@argo.co.il> <18035.3009.568832.785308@notabene.brown> <20070618045759.GD85884050@sgi.com> <18041.59628.370832.633244@notabene.brown> <20070621063936.GT85884050@sgi.com> <Pine.LNX.4.64.0706202341080.31603@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706202341080.31603@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Thu, 21 Jun 2007, David Chinner wrote:
> one of the 'killer features' of zfs is that it does checksums of every 
> file on disk. so many people don't consider the disk infallable.
> 
> several other filesystems also do checksums
> 
> both bitkeeper and git do checksums of files to detect disk corruption

How different is that to raid1/5/6 being set to a 'paranoid' "read-verify" mode 
(as per Dan's recent email) where a read reads from _all_ spindles and verifies 
(and with R6 maybe corrects) the stripe before returning it?

Doesn't solve DaveC's issue about the fs doing redundancy but isn't that 
essentially just fs level mirroring?

David

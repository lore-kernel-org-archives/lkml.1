Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbYADXDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbYADXDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 18:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbYADXDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 18:03:15 -0500
Received: from main.gmane.org ([80.91.229.2]:48334 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323AbYADXDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 18:03:14 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: memory remapping, 4gb memory on 945gt
Date: Fri, 4 Jan 2008 23:02:56 +0000 (UTC)
Message-ID: <loom.20080104T225120-118@post.gmane.org>
References: <20080104154914.GA589@codeblau.de> <p73lk758sri.fsf@bingen.suse.de> <20080104181918.GA21797@gallifrey> <477EAD37.4070903@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 76.112.242.129 (Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9b2) Gecko/2007121120 Firefox/3.0b2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa <at> zytor.com> writes:

> 
> Supposedly WinXP-32 doesn't use memory over 4 GB even if it is available 
> (a market-segmentation decision of the part of Microsoft, to force 
> people to buy WinServer 2003; WinXP SP2 does PAE so there is no 
> technical reason.)  This probably has disincentivized hardware vendors 
> from providing support for remapping the memory from the aperture above 
> the 4 GB mark.  The logic isn't all that trivial, especially if the 
> aperture size is configurable, so I can understand why they would punt.
> 

The reason according to Microsoft is that enabling PAE induced driver
incompatibilities - to me it sounds quite plausible given the quality of drivers
for consumer versions of XP/Vista and the fact that 4GB RAM in consumer class
machine is a newer thing.

There is a KB document detailing the reasons for disabling >4Gb RAM in XP SP2
and later 32-bit OSes - http://support.microsoft.com/kb/888137 .

Parag



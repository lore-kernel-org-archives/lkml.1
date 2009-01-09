Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbZAISVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbZAISVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZAISVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:21:00 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:57346 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbZAISVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:21:00 -0500
Message-ID: <49679570.3070403@csr.com>
Date: Fri, 09 Jan 2009 18:20:32 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Enrik Berkhan <Enrik.Berkhan@ge.com>
CC: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: Reference counting of MMC host driver modules
References: <49678443.8040909@ge.com>
In-Reply-To: <49678443.8040909@ge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jan 2009 18:20:32.0805 (UTC) FILETIME=[F593AD50:01C97286]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enrik Berkhan wrote:
> Hi,
> 
> I've noticed recently that the MMC/SD block driver does not reference 
> count the MMC/SD host driver module that it uses via the MMC/SD core 
> layer. Thus, I can rmmod my host driver module while, for example, a 
> partition on a SD card is mounted.

This is same as removing the card while it's in use.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/

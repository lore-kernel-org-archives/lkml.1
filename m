Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbZAIUCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbZAIUCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbZAIUAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:00:39 -0500
Received: from ext-nj2ut-6.online-age.net ([64.14.54.235]:61301 "EHLO
	ext-nj2ut-6.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755453AbZAIUAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:00:36 -0500
Date: Fri, 9 Jan 2009 21:00:24 +0100
From: Enrik Berkhan <Enrik.Berkhan@ge.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: Reference counting of MMC host driver modules
Message-ID: <20090109200024.GA14754@ngeserver2.localdomain>
References: <49678443.8040909@ge.com> <49679570.3070403@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49679570.3070403@csr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 09 Jan 2009 20:00:29.0478 (UTC) FILETIME=[EBDF5C60:01C97294]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 06:20:32PM +0000, David Vrabel wrote:
> Enrik Berkhan wrote:
> > I've noticed recently that the MMC/SD block driver does not reference 
> > count the MMC/SD host driver module that it uses via the MMC/SD core 
> > layer. Thus, I can rmmod my host driver module while, for example, a 
> > partition on a SD card is mounted.
> 
> This is same as removing the card while it's in use.

I don't think so.

Being able to remove the card while it is in use is a bug of the
mechanical interface. Can't be fixed easily.

Being able to remove the module while it is in use is a bug of the
software. Can be fixed.

Enrik

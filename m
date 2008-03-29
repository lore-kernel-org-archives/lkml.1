Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbYC2P43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbYC2P43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 11:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYC2Pz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 11:55:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:59585 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbYC2Pzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 11:55:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=b5tsuOG5jZ89L8eBMg7iXnGMgdpMJ4o21oDVGjTQibQWJttBCB4iky9M70w4UXkU3dXol2/kTDraPgaAzbv5gVmnm14DgAg8etdlarsiGbp0JcJROgnhaFbL+QZhJM5gPv7EI2E75wDVIdyGGDeBjC+75mxFlBOYoshgZffXYN0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH 15/18] ide: remove broken/dangerous HDIO_[UNREGISTER,SCAN]_HWIF ioctls
Date: Sat, 29 Mar 2008 17:10:54 +0100
User-Agent: KMail/1.9.9
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain> <47EBDBAA.2020308@ru.mvista.com> <47ED439C.9030400@rtr.ca>
In-Reply-To: <47ED439C.9030400@rtr.ca>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803291710.54843.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008, Mark Lord wrote:
> Sergei Shtylyov wrote:
> > Bartlomiej Zolnierkiewicz wrote:
> > 
> >> hdparm explicitely marks HDIO_[UNREGISTER,SCAN]_HWIF ioctls as DANGEROUS
> >> and given the number of bugs we can assume that there are no real users:
> ..
> 
> There is the odd user of these, actually.
> 
> But the most recent to email me (a few weeks ago),
> reported that the SCAN function was no longer working on his kernel.
> 
> I'll remove the -R and -U flags completely from hdparm-8.7.

This will be quite helpful, thanks!

Bart

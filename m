Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbZFFImy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbZFFImy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 04:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbZFFImq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 04:42:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58740 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbZFFImq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 04:42:46 -0400
Date: Sat, 6 Jun 2009 09:42:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH 2/4] partitions: add ->set_capacity block device method
Message-ID: <20090606084247.GA19924@ZenIV.linux.org.uk>
References: <20090531143911.7164.26834.sendpatchset@localhost.localdomain> <20090531143924.7164.25770.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090531143924.7164.25770.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 31, 2009 at 04:39:24PM +0200, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] partitions: add ->set_capacity block device method
> 
> * Add ->set_capacity block device method and use it in rescan_partitions()
>   to attempt enabling native capacity of the device upon detecting the
>   partition which exceeds device capacity.
> 
> * Add GENHD_FL_NATIVE_CAPACITY flag to try limit attempts of enabling
>   native capacity during partition scan.
> 
> Together with the consecutive patch implementing ->set_capacity method in
> ide-gd device driver this allows automatic disabling of Host Protected Area
> (HPA) if any partitions overlapping HPA are detected.
> 
> Cc: Robert Hancock <hancockrwd@gmail.com>
> Cc: Frans Pop <elendil@planet.nl>
> Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
> Cc: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Al Viro <viro@zeniv.linux.org.uk>

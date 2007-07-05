Return-Path: <linux-kernel-owner+w=401wt.eu-S1761492AbXGEN0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761492AbXGEN0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758745AbXGEN0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:26:36 -0400
Received: from edu.joroinen.fi ([194.89.68.130]:44378 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758663AbXGEN0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:26:36 -0400
X-Greylist: delayed 1603 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2007 09:26:36 EDT
Date: Thu, 5 Jul 2007 15:59:51 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Dmitry Melekhov <dm@belkam.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: scsi lun online resize
Message-ID: <20070705125951.GF4106@edu.joroinen.fi>
References: <46652EB3.4060903@belkam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46652EB3.4060903@belkam.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 02:36:51PM +0500, Dmitry Melekhov wrote:
> Hello!
> 
> I'm playing with iscsi on linux.
> And I have following problem:
> 
> If I change lun size on target side and then do echo "1" >/sys/block/
> sdb/device/rescan
> device size is changed only if /dev/sdb is not mounted, if it is
> mounted fdisk shows no size change, so lun can't be resized online.
> 
> open-iscsi guys say this is general linux problem, not iscsi specific.
> Could you tell me is there any solution?
> 

Do you have partition table on /dev/sdb, or are you using /dev/sdb directly? 

-- Pasi

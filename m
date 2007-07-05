Return-Path: <linux-kernel-owner+w=401wt.eu-S1762807AbXGEWKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762807AbXGEWKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760001AbXGEWKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:10:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36095 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760922AbXGEWKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:10:13 -0400
Message-ID: <468D6C17.8030006@torque.net>
Date: Thu, 05 Jul 2007 18:09:27 -0400
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: James.Bottomley@SteelEye.com, akpm@linux-foundation.org, jeff@garzik.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] clean gendisk out of scsi ULD structs
References: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com>
In-Reply-To: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Since gendisk will now become part of struct scsi_device, we don't need
> to store this value in any private data structs where they already store
> scsi_device.  This series cleans up a few drivers which did this.

Since a scsi_device object is usually a SCSI logical unit,
one wonders why it would contain a gendisk object. Logical
units aren't necessarily disks, they might be enclosures or
just place holders that respond to an INQUIRY (e.g. lun=0
when the enclosing target has other active lus whose lun!=0).

Doug Gilbert

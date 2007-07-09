Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbXGINJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbXGINJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXGINJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:09:13 -0400
Received: from edu.joroinen.fi ([194.89.68.130]:38802 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbXGINJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:09:12 -0400
Date: Mon, 9 Jul 2007 16:09:10 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Dmitry Melekhov <dm@belkam.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: scsi lun online resize
Message-ID: <20070709130910.GH4106@edu.joroinen.fi>
References: <46652EB3.4060903@belkam.com> <20070705125951.GF4106@edu.joroinen.fi> <468D1344.30007@belkam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <468D1344.30007@belkam.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 08:50:28PM +0500, Dmitry Melekhov wrote:
> Pasi Kärkkäinen wrote:
> >On Tue, Jun 05, 2007 at 02:36:51PM +0500, Dmitry Melekhov wrote:
> >  
> >>Hello!
> >>
> >>I'm playing with iscsi on linux.
> >>And I have following problem:
> >>
> >>If I change lun size on target side and then do echo "1" >/sys/block/
> >>sdb/device/rescan
> >>device size is changed only if /dev/sdb is not mounted, if it is
> >>mounted fdisk shows no size change, so lun can't be resized online.
> >>
> >>open-iscsi guys say this is general linux problem, not iscsi specific.
> >>Could you tell me is there any solution?
> >>
> >>    
> >
> >Do you have partition table on /dev/sdb, or are you using /dev/sdb 
> >directly? 
> >
> >  
> I tried both...
> 

Did you try:

echo "- - -" > /sys/class/scsi_host/hostX/scan

That works at least with Qlogic iSCSI HBA (qla4xxx).

-- Pasi

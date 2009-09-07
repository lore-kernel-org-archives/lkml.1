Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbZIGRFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbZIGRFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 13:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZIGRFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 13:05:21 -0400
Received: from static-173-48-39-13.bstnma.fios.verizon.net ([173.48.39.13]:56361
	"EHLO lifeintegrity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbZIGRFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 13:05:20 -0400
X-Greylist: delayed 618 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Sep 2009 13:05:20 EDT
Date: Mon, 7 Sep 2009 12:55:04 -0400
From: Allan Wind <allan_wind@lifeintegrity.com>
To: Chris Webb <chris@arachsys.com>
Cc: linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
Message-ID: <20090907165504.GJ31003@lifeintegrity.com>
Mail-Followup-To: Chris Webb <chris@arachsys.com>,
	linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>,
	Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>,
	NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
	IDE/ATA development list <linux-ide@vger.kernel.org>,
	Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
References: <4A950FA6.4020408@redhat.com> <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost> <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com> <4A9B8583.9050601@kernel.org> <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org> <20090907114442.GG18831@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907114442.GG18831@arachsys.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-09-07T12:44:42, Chris Webb wrote:
> Sorry for the late follow up to this thread, but I'm also seeing symptoms that
> look identical to these and would be grateful for any advice. I think I can
> reasonably rule out a single faulty drive, controller or cabling set as I'm
> seeing it across a cluster of Supermicro machines with six Seagate ST3750523AS
> SATA drives in each and the drive that times out is apparently randomly
> distributed across the cluster. (Of course, since the hardware is identical, it
> could still be a hardware design or firmware problem.)

Seeing the same thing with a Supermicro motherboard and a pair WDC 2 TB 
drives.  Disabling NCQ does not resolve the issue, nor increasing 
the safe_mode_delay.  This is with 2.6.30.4.  This machine is 
sitting on its hand (i.e. no significant load).


/Allan
-- 
Allan Wind
Life Integrity, LLC
<http://lifeintegrity.com>


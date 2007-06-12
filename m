Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbXFLB7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbXFLB7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 21:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757469AbXFLB71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 21:59:27 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:18492 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452AbXFLB70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 21:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UEhyUXBI2qqvCDX5LMI8tvxO63r3ut3cffpyvQLhW36XT5cg34c4muvBZxcA/WzGDDak2D3NKUCEgYChOY2rrdSctXcDSWntO2E8kgCPjKa7NtQx1Jn6wbCiyU8FUM3MinFTBLVYIlSUq3jGNa6//TkXslpreySWAjxjLDmXhZQ=
Message-ID: <466DFDB5.9030901@gmail.com>
Date: Tue, 12 Jun 2007 10:58:13 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: jeff@garzik.org, james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com
Subject: Re: [patch 0/3] AHCI Link Power Management
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com>
In-Reply-To: <20070611114600.7fca1c24.kristen.c.accardi@intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Hi,
> This series of patches enables Aggressive Link Power Management for AHCI 
> devices, as documented in the AHCI spec.  On my laptop (a Lenovo X60), this
> saves me a full watt of power.  On other systems, reported power savings
> range from .5-1.5 Watts.  It has been tested by the kind folks at #powertop
> with similar results.  Please give it a try and let me know what you think.

I'm not sure about this.  We need better PM framework to support
powersaving in other controllers and some ahcis don't save much when
only link power management is used, they need to be turned off
completely && I don't think scsi sysfs is the right place to export this
interface.

-- 
tejun

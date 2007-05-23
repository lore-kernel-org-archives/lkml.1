Return-Path: <linux-kernel-owner+w=401wt.eu-S1760801AbXEWWYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760801AbXEWWYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757553AbXEWWYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:24:21 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:4123 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943AbXEWWXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:23:42 -0400
X-IronPort-AV: i="4.14,571,1170662400"; 
   d="scan'208"; a="156815114:sNHT41076927"
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIE
X-Message-Flag: Warning: May contain useful information
References: <46543045.3030904@gmail.com> <20070523155958.GA5282@kroah.com>
	<4654AB40.6060208@gmail.com> <adaejl79rh0.fsf@cisco.com>
	<4654BC10.2000808@gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 23 May 2007 15:23:40 -0700
In-Reply-To: <4654BC10.2000808@gmail.com> (Manu Abraham's message of "Thu, 24 May 2007 02:11:28 +0400")
Message-ID: <adazm3v89hv.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 May 2007 22:23:40.0944 (UTC) FILETIME=[042C4900:01C79D89]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > If i uncomment the saa716x_read or write, what i get is a solid freeze
 > on module load. If i leave it commented out, the module loads fine.

That sounds like a typical bug during driver development... you're
probably wedging the hardware by doing the wrong access.

I didn't see the source for saa716x_read or write in the code you
posted, so it's hard to say if there's a problem with them.

Is your interrupt handler getting called?  Is the device generating
interrupts?

 > That part is then fine. Does MSI require any special tinkering ?

Just pci_enable_msi() as usual.

 - R.

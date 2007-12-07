Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbXLGAaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbXLGAaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 19:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbXLGA3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 19:29:44 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:48412 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbXLGA3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 19:29:42 -0500
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, akpm@linux-foundation.org,
       jeff@garzik.org, jkosina@suse.cz, jslaby@suse.cz,
       stephen@symmetric.co.nz, benm@symmetric.co.nz
Message-Id: <6E0FAD91-89C3-48E4-B8FB-4BD682DE6144@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: David Sterba <dsterba@suse.cz>
In-Reply-To: <200712041833.28743.dsterba@suse.cz>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH] ipwireless_cs driver for 4G PC Card
Date: Fri, 7 Dec 2007 01:28:28 +0100
References: <20071130125555.GA10977@ds.suse.cz> <alpine.LFD.0.9999.0711300759200.29812@localhost.localdomain> <200712041833.28743.dsterba@suse.cz>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

>> might it not make more sense to put all of that into a new
>> subdirectory, say, /drivers/char/pcmcia/ipwireless_cs?  that way,  
>> it's
>> more modular and it will keep that higher-level directory from
>> potentially getting cluttered with even more drivers.  and it would
>> let you drop the pointless "ipwireless_cs_" prefix from all of those
>> files as well.
>
> ok, will put it into ipwireless, and the _cs suffix will go away as  
> suggested
> elsewhere. The filenames will then get very generic names, do you have
> suggestion for better names? There are many drivers in own directory  
> and
> files inside have the same prefix. Maybe we can use names like ipw- 
> hw.c, etc.

don't use "ipw" as prefix. It is too close to the Intel wireless  
drivers and will only create confusion. The generic filenames in a  
subdirectory don't matter. The module name is what counts.

Regards

Marcel


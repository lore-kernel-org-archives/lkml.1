Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbZBQXB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbZBQXB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbZBQXBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:01:09 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:51456 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbZBQXBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:01:07 -0500
Date: Tue, 17 Feb 2009 16:00:50 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: david@lang.hm
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       DL-MPTFusionLinux@lsi.com
Subject: Re: mpt fusion broken sometime since 2.6.24
Message-ID: <20090217230050.GG16841@parisc-linux.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 01:44:55PM -0800, david@lang.hm wrote:
> I got a picture of the failed boot at 
> http://linux.lang.hm/linux/IMG00052.jpg

The PCI-MSI line is probably indicative.  Can you try booting with:

mptbase.mpt_msi_enable_sas=0

and also send us an lspci -v so we can update the blacklist?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

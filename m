Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbZBQXHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbZBQXHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZBQXHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:07:33 -0500
Received: from mail.lang.hm ([64.81.33.126]:52383 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbZBQXHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:07:32 -0500
Date: Tue, 17 Feb 2009 15:07:26 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Wilcox <matthew@wil.cx>
cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       DL-MPTFusionLinux@lsi.com
Subject: Re: mpt fusion broken sometime since 2.6.24
In-Reply-To: <20090217230050.GG16841@parisc-linux.org>
Message-ID: <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm> <20090217230050.GG16841@parisc-linux.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009, Matthew Wilcox wrote:

> On Tue, Feb 17, 2009 at 01:44:55PM -0800, david@lang.hm wrote:
>> I got a picture of the failed boot at
>> http://linux.lang.hm/linux/IMG00052.jpg
>
> The PCI-MSI line is probably indicative.  Can you try booting with:
>
> mptbase.mpt_msi_enable_sas=0
>
> and also send us an lspci -v so we can update the blacklist?

is that disabling SAS for this system? if so, that's the wrong thing to do 
(the drives are SAS)

David Lang

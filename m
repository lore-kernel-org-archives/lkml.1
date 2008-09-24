Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYIXUS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYIXUS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYIXUSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:18:18 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:53429 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbYIXUSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nEMltn6Glyj2pGluJd48l/EvTGb2SCRhydPxrtrtA8jHV5PJYuEcpghS+IIMum7hZ/
         Kb/51dRS6SgJcoYvuFcrUe/XEX1RjD7GV4vf5sl9G/VZrhJ5YSAVEiJVLUrlaj4YeKYt
         /A0IRnSGqR7GRJhlsBF94u20nmiLt/vtWI0DE=
Message-ID: <21d7e9970809241318s2717e121ic53f1357898a2cd0@mail.gmail.com>
Date: Thu, 25 Sep 2008 06:18:16 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Cc: "David Miller" <davem@davemloft.net>, jeffrey.t.kirsher@intel.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com
In-Reply-To: <alpine.LNX.1.10.0809241836180.4671@pegasus.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970809232245x6a91c6e2l552ff039d07e2017@mail.gmail.com>
	 <20080924.003638.71148740.davem@davemloft.net>
	 <21d7e9970809240159u6db747eex51892061846b2251@mail.gmail.com>
	 <20080924.020116.193720569.davem@davemloft.net>
	 <21d7e9970809240216m4a93a339sb51a5928fcb5f6fb@mail.gmail.com>
	 <alpine.LNX.1.10.0809241829500.4671@pegasus.suse.cz>
	 <alpine.LNX.1.10.0809241836180.4671@pegasus.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 2:37 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 24 Sep 2008, Jiri Kosina wrote:
>
>> Dave (Airlie, too many Daves on CC here really), do you by any chance
>> see any recent change in kernel intel graphic parts of DRM be causing
>> this breakage?
>
> BTW, why is the PAT fix implented in commit 242e3df80 needed only for
> radeons?
>

Good question, mainly because only radeons showed the illegal mapping crash,
which was mapping via sysfs _wc files and then doing a UC mapping in
the kernel over the
same address space would fail. However this was VRAM related and these
things don't have VRAM.

Dave.

> --
> Jiri Kosina
> SUSE Labs
>

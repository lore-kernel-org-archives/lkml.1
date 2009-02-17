Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbZBQXLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbZBQXLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbZBQXLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:11:05 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:33097 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbZBQXLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:11:03 -0500
Date: Tue, 17 Feb 2009 16:11:01 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: david@lang.hm
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       DL-MPTFusionLinux@lsi.com
Subject: Re: mpt fusion broken sometime since 2.6.24
Message-ID: <20090217231101.GH16841@parisc-linux.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm> <20090217230050.GG16841@parisc-linux.org> <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 03:07:26PM -0800, david@lang.hm wrote:
> >mptbase.mpt_msi_enable_sas=0
> 
> is that disabling SAS for this system? if so, that's the wrong thing to do 
> (the drives are SAS)

no, it's disabling msi for sas controllers.

nb, I said this patch (e382968ba618e016ff7922dff9a6140c2f9108c8) was
the wrong way to go about getting MSI working.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823Ab0AGTeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab0AGTeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762Ab0AGTeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:34:15 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54879 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab0AGTeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:34:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UFGnBOfcPVTQhEvLM9Ojc+TseEP318GKCVGqXLzSynpW8SupJqbrf3+bfMpyuwDECw
         NemMwug358X4M2qAgXE7egNk/CYDOmYG3oJ+dUPuhoPb5yLoEo+UwckxYk0hdGWzZLb1
         ZDlz2/O1n6qcBEZif/Y8e1qy54OgRm+787KWg=
Date: Thu, 7 Jan 2010 22:34:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       brgerst@gmail.com, hpa@zytor.com
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
	tables
Message-ID: <20100107193405.GC5460@lenovo>
References: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de> <4B4405B5.9040205@goop.org> <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de> <20100106112133.GA5815@lenovo> <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de> <alpine.DEB.2.01.1001071101030.3483@bogon.housecafe.de> <20100107192018.GB5460@lenovo> <alpine.DEB.2.01.1001071131100.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1001071131100.3483@bogon.housecafe.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 11:31:41AM -0800, Christian Kujau wrote:
> On Thu, 7 Jan 2010 at 22:20, Cyrill Gorcunov wrote:
> > for the first "guilty" commit -- it seems to be innocent, at least
> > from the way how kernel_thread is converted into "C". Need time for
> > more detailed review :/
> 
> OK, thanks for looking into this.
> 
> Christian.
> -- 
> BOFH excuse #429:
> 
> Temporal anomaly
>

Well, Peter is much more experienced in this area and as he
already pointed -- pt_regs now zero'ed with new kernel_thread...
 
	-- Cyrill

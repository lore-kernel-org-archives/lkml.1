Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbZLSHeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbZLSHeM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 02:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbZLSHeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 02:34:11 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:58740 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbZLSHeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 02:34:10 -0500
Date: Sat, 19 Dec 2009 18:34:06 +1100
From: Simon Horman <horms@verge.net.au>
To: Roland Dreier <rdreier@cisco.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: Re: kexec reboot broken with ioatdma?
Message-ID: <20091219073406.GG9764@verge.net.au>
References: <ada3a3a8v1g.fsf@roland-alpha.cisco.com>
 <20091216224912.GC16219@verge.net.au>
 <aday6l27c7w.fsf@roland-alpha.cisco.com>
 <4B296930.9020704@intel.com>
 <adatyvq7bbi.fsf@roland-alpha.cisco.com>
 <1261174241.16958.6.camel@dwillia2-linux.ch.intel.com>
 <adafx773ox9.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adafx773ox9.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 02:20:02PM -0800, Roland Dreier wrote:
> 
>  > Subject: ioat2,3: put channel hardware in known state at init
>  > 
>  > Put the ioat2 and ioat3 state machines in the halted state with all
>  > errors cleared.
> 
> Yes, with this applied I was able to kexec reboot from a kernel with
> ioatdma loaded and have ioatdma work in the new kernel.  So:
> 
> Tested-by: Roland Dreier <rolandd@cisco.com>

This seems fine to me from a kexec point of view

Acked-by: Simon Horman <horms@verge.net.au>

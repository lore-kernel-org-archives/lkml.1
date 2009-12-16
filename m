Return-Path: <linux-kernel-owner+w=401wt.eu-S934625AbZLPXpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934625AbZLPXpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934393AbZLPXpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:45:32 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:33072 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933946AbZLPXpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:45:32 -0500
Date: Thu, 17 Dec 2009 10:45:29 +1100
From: Simon Horman <horms@verge.net.au>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
       kexec@lists.infradead.org
Subject: Re: kexec reboot broken with ioatdma?
Message-ID: <20091216234529.GB22449@verge.net.au>
References: <ada3a3a8v1g.fsf@roland-alpha.cisco.com>
 <20091216224912.GC16219@verge.net.au>
 <aday6l27c7w.fsf@roland-alpha.cisco.com>
 <20091216233613.GA22449@verge.net.au>
 <adapr6e7ag3.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adapr6e7ag3.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 03:42:20PM -0800, Roland Dreier wrote:
> 
>  > If its reset in a standard path, then yes that seems sensible to me.
>  > I'm mainly concerned about avoiding something along the lines of:
>  > 
>  > 	if (is_booting_from_kexec)
>  > 		reset_hw();
> 
> I think we all agree... the idea is to change from
> 
> 	init_hw()
> 	{
> 		/* assume hw is in pristine state */
> 		do_init();
> 	}
> 
> to
> 
> 	init_hw()
> 	{
> 		/* hw is in unknown state */
> 		reset_hw();
> 		do_init();
> 	}
> 
>  - R.

Yes, I think we all agree :-)


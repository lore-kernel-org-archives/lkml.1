Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbYAUSJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbYAUSJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 13:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYAUSJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 13:09:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:62338 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbYAUSJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 13:09:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=KLYaxKIR0WSjqgUOS9WZ2SpZ0YyEBmVmhPNkXqjzql3TvaPMBTjL4Mjkquf74+DINmgGp4iG/DfW/aaw68oEzXO+oCF5QYimwrZ7z5mulKXuPy7JV0agivjqvXulTRQZzyW2eSe2x2DjyK2NOZFcHjmOFD8Nm490/IFDVIiigcA=
Date: Mon, 21 Jan 2008 21:09:13 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: Yinghai Lu <Yinghai.Lu@sun.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: check if Tom2 is enabled
Message-ID: <20080121180913.GD6722@cvg>
References: <200801192045.17291.yinghai.lu@sun.com> <200801202257.47195.yinghai.lu@sun.com> <20080121172437.GA6722@cvg> <200801211903.27215.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801211903.27215.ak@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andi Kleen - Mon, Jan 21, 2008 at 07:03:27PM +0100]
| 
| > is it possible to change 'l' and 'h' to 'low' and 'high'?
| > 'cause 'l' does look like '1' (one) number...
| 
| It would be fine for me for someone to implement safe_rdtscll() and get rid
| of l and h everywhere. IMHO all the l and h accesses of MSRs are just harder
| to read and error prone over the ll 64bit variants.
| 
| But I didn't want to add it just for this.
| 
| -Andi
| 

clear enough, thanks

		- Cyrill -

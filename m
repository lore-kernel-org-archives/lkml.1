Return-Path: <linux-kernel-owner+w=401wt.eu-S1762391AbYETR6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762391AbYETR6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbYETR5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:57:55 -0400
Received: from outbound-mail-146.bluehost.com ([67.222.38.36]:53115 "HELO
	outbound-mail-146.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754581AbYETR5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:57:54 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH] PCI: boot parameter to avoid expansion ROM memory allocation
Date: Tue, 20 May 2008 10:57:49 -0700
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <20080512205746.GB7401@us.ibm.com> <20080514000702.GA12546@us.ibm.com> <20080514162015.GA6713@us.ibm.com>
In-Reply-To: <20080514162015.GA6713@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201057.49679.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 14, 2008 9:20 am Gary Hade wrote:
> > Correct, not a perfect solution but better than we have right now.
>
> ...but don't let this comment make you think that I am not in
> favor of something like you are suggesting.  I am interested
> in getting the 'pci=norom' change into mainline quickly but it
> is obviously less than ideal for the long term.
>
> Jesse, any idea how many different devices absolutely need
> memory allocated for their expansion ROMs?

Unless there's a ton of demand, I'd rather go with the norom option, but 
either way, I'd like to push the fix early in the 2.6.27 cycle rather than 
trying to get it into 2.6.26 at the last minute...

So assuming you're ok with your last patch, I'll stuff it into linux-next.

Thanks,
Jesse


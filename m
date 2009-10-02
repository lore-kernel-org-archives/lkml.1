Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbZJBRYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbZJBRYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757375AbZJBRYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:24:34 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:34602 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbZJBRYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:24:34 -0400
Message-ID: <4AC636F7.2000506@csr.com>
Date: Fri, 02 Oct 2009 18:23:03 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg KH <gregkh@suse.de>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [109/136] USB: xhci: Make TRB completion code comparison
 readable.
References: <20091002011548.335611824@mini.kroah.org> <20091002012424.339883108@mini.kroah.org> <4AC62C8C.4060906@csr.com> <20091002165316.GB3890@kroah.com>
In-Reply-To: <20091002165316.GB3890@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2009 17:23:04.0129 (UTC) FILETIME=[FFE2FB10:01CA4384]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Oct 02, 2009 at 05:38:36PM +0100, David Vrabel wrote:
>> Greg KH wrote:
>>> 2.6.31-stable review patch.  If anyone has any objections, please let us know.
>>>
>>> ------------------
>>> From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
>>>
>>> commit 66d1eebce5cca916e0b08d961690bb01c64751ef upstream.
>>>
>>> Use trb_comp_code instead of getting the completion code from the transfer
>>> event every time.
>> Are all these xhci patches really candidates for the stable tree?  XHCI
>> support is marked as EXPERIMENTAL, the xhci standard is still at the
>> draft stage, and I don't believe there are any xhci products available
>> on the market yet.
> 
> Did you read the 000/136 message where I explained why I was accepting
> all of these xhci patches into the -stable tree?

I have now, sorry.  It just seemed odd that XHCI patches where added to
stable releases whilst essential WHCI patches don't even make it into
the current rc tree.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbYD1EtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbYD1EtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 00:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYD1Es6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 00:48:58 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:55495 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYD1Es5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 00:48:57 -0400
Date: Mon, 28 Apr 2008 10:18:54 +0530
From: "K. Prasad" <prasad@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: prasad@linux.vnet.ibm.com, dwilder@us.ibm.com,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       hunt@redhat.com, dave@linux.vnet.ibm.com
Subject: Re: [RFC Patch 1/1] debugfs_printk and debugfs_dump interface
Message-ID: <20080428044854.GA5437@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20080415111459.GB5295@in.ibm.com> <20080415112603.GA5770@in.ibm.com> <48066EBE.3040608@us.ibm.com> <20080421124329.GA14118@in.ibm.com> <4810FA44.9060402@us.ibm.com> <20080425074200.GA8600@in.ibm.com> <20080425081959.GA15011@in.ibm.com> <1209343851.8118.1.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209343851.8118.1.camel@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 10:50:51AM +1000, Michael Ellerman wrote:
> On Fri, 2008-04-25 at 13:49 +0530, K. Prasad wrote:
> > On Fri, Apr 25, 2008 at 01:12:00PM +0530, K. Prasad wrote:
> > > Please find the new patch below.
> > > > 
> > Let the email slip through a little early. Please find the revised
> > patch below.
> > 
> > Thanks,
> > K.Prasad
> > 
> > This patch introduces two new interfaces called debugfs_printk and 
> > debugfs_dump which can be used to print to the debugfs mount directly.
> > It uses the 'trace' infrastructure underneath and is a patch over it.
> > A sample file is also created to demonstrate its ease of use.
> 
> I still think debugfs_printk() is not the right name, as it is not part
> of the existing family of debugfs_* routines.
Whether to call it trace_printk() and trace_dump() is a suggestion I
would like to ask David Wilder (and others). Let me know if you think
there are better names.

Thanks,
K.Prasad


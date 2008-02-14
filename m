Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbYBNPxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbYBNPxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYBNPxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:53:39 -0500
Received: from relay2.sgi.com ([192.48.171.30]:50609 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753042AbYBNPxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:53:38 -0500
Date: Thu, 14 Feb 2008 09:53:33 -0600
From: Robin Holt <holt@sgi.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: Felix Marti <felix@chelsio.com>, Roland Dreier <rdreier@cisco.com>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       steiner@sgi.com, Andrea Arcangeli <andrea@qumranet.com>,
       a.p.zijlstra@chello.nl, izike@qumranet.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: Demand paging for memory regions
Message-ID: <20080214155333.GA1029@sgi.com>
References: <adazlu5vlub.fsf@cisco.com> <8A71B368A89016469F72CD08050AD334026D5C23@maui.asicdesigners.com> <47B45994.7010805@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B45994.7010805@opengridcomputing.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 09:09:08AM -0600, Steve Wise wrote:
> Note that for T3, this involves suspending _all_ rdma connections that are 
> in the same PD as the MR being remapped.  This is because the driver 
> doesn't know who the application advertised the rkey/stag to.  So without 

Is there a reason the driver can not track these.

> Point being, it will stop probably all connections that an application is 
> using (assuming the application uses a single PD).

It seems like the need to not stop all would be a compelling enough reason
to modify the driver to track which processes have received the rkey/stag.

Thanks,
Robin

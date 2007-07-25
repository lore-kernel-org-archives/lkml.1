Return-Path: <linux-kernel-owner+w=401wt.eu-S934683AbXGYSx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934683AbXGYSx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934848AbXGYSxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:53:09 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54076 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934216AbXGYSxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:53:07 -0400
Message-ID: <46A79C00.200@cs.wisc.edu>
Date: Wed, 25 Jul 2007 13:52:48 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
CC: James Bottomley <James.Bottomley@steeleye.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       Roland Dreier <rdreier@cisco.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       general@lists.openfabrics.org
Subject: Re: [PATCH trivial] include linux/mutex.h from scsi_transport_iscsi.h
References: <20070725110907.GF3826@mellanox.co.il>
In-Reply-To: <20070725110907.GF3826@mellanox.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
> scsi/scsi_transport_iscsi.h uses struct mutex, so while
> linux/mutex.h seems to be pulled in indirectly
> by one of the headers it includes, the right thing
> is to include linux/mutex.h directly.
> 

Is that part about always including the header directly right? If so 
then were you going to include list.h too, and were you going to fix up 
some of the other iscsi code?

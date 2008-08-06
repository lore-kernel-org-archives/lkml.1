Return-Path: <linux-kernel-owner+w=401wt.eu-S1759861AbYHFQhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861AbYHFQhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbYHFQhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:37:05 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40818 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754837AbYHFQhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:37:03 -0400
Subject: Re: [PATCH][SCS] sd: Read Capacity if (16) fails
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0808061629220.10184@blonde.site>
References: <Pine.LNX.4.64.0808061500450.1109@blonde.site>
	 <yq1d4kmi5hl.fsf@sermon.lab.mkp.net>
	 <Pine.LNX.4.64.0808061629220.10184@blonde.site>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 09:36:53 -0700
Message-Id: <1218040613.7493.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 16:34 +0100, Hugh Dickins wrote:
>   PQual=0  Device_type=0  RMB=1  version=0x00  [no conformance
> claimed]

We could try using this as the trigger.  I assume all DIF supporting
devices must also claim conformance to SPC3/SBC2 or higher?

James



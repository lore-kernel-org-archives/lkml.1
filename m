Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYHFQxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYHFQxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbYHFQui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:50:38 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61660 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbYHFQue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:50:34 -0400
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hugh Dickins <hugh@veritas.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][SCS] sd: Read Capacity if (16) fails
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <Pine.LNX.4.64.0808061500450.1109@blonde.site>
	<yq1d4kmi5hl.fsf@sermon.lab.mkp.net>
	<Pine.LNX.4.64.0808061629220.10184@blonde.site>
	<1218040613.7493.13.camel@localhost.localdomain>
Date: Wed, 06 Aug 2008 12:44:16 -0400
In-Reply-To: <1218040613.7493.13.camel@localhost.localdomain> (James Bottomley's message of "Wed\, 06 Aug 2008 09\:36\:53 -0700")
Message-ID: <yq1bq06w0tb.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> On Wed, 2008-08-06 at 16:34 +0100, Hugh Dickins wrote:
>> PQual=0 Device_type=0 RMB=1 version=0x00 [no conformance claimed]

James> We could try using this as the trigger.  I assume all DIF
James> supporting devices must also claim conformance to SPC3/SBC2 or
James> higher?

You'd think, wouldn't you?

Originally I only checked for PROTECT if version was SBC2 or better.
But as it turns out I have drives that only report SBC and yet they do
DIF.  This old version is apparently reported to prevent problems in
other operating systems.

*sigh*

-- 
Martin K. Petersen	Oracle Linux Engineering


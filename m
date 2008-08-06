Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbYHFO2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbYHFO2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 10:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbYHFO2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 10:28:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49441 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbYHFO2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 10:28:18 -0400
To: Hugh Dickins <hugh@veritas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][SCS] sd: Read Capacity if (16) fails
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <Pine.LNX.4.64.0808061500450.1109@blonde.site>
Date: Wed, 06 Aug 2008 10:27:02 -0400
In-Reply-To: <Pine.LNX.4.64.0808061500450.1109@blonde.site> (Hugh Dickins's message of "Wed\, 6 Aug 2008 15\:06\:21 +0100 \(BST\)")
Message-ID: <yq1d4kmi5hl.fsf@sermon.lab.mkp.net>
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

>>>>> "Hugh" == Hugh Dickins <hugh@veritas.com> writes:

Hugh> Commit e0597d70012c82e16ee152270a55d89d8bf66693 (sd: Identify
Hugh> DIF protection type and application tag ownership) says that if
Hugh> a disk is formatted with Inquiry bit PROTECT=1, it is required
Hugh> to support Read Capacity(16).  But my SD cards, accessed by
Hugh> builtin cardreader and generic USB storage, disagree.

Argh.  That's really broken.  USB storage has no business setting
PROTECT.

Can you send me the sg_inq output so I can see what else they are
returning?

-- 
Martin K. Petersen	Oracle Linux Engineering


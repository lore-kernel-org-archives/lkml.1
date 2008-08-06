Return-Path: <linux-kernel-owner+w=401wt.eu-S1761983AbYHFRh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761983AbYHFRh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbYHFRhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 13:37:12 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55987 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756008AbYHFRhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 13:37:11 -0400
Subject: Re: [PATCH][SCS] sd: Read Capacity if (16) fails
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <yq17iauvylo.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.64.0808061500450.1109@blonde.site>
	 <yq1d4kmi5hl.fsf@sermon.lab.mkp.net>
	 <Pine.LNX.4.64.0808061629220.10184@blonde.site>
	 <1218040613.7493.13.camel@localhost.localdomain>
	 <1218041582.7493.19.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0808061815360.27392@blonde.site>
	 <yq17iauvylo.fsf@sermon.lab.mkp.net>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 10:36:57 -0700
Message-Id: <1218044217.7493.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 13:32 -0400, Martin K. Petersen wrote:
> >>>>> "Hugh" == Hugh Dickins <hugh@veritas.com> writes:
> 
> Hugh> Almost: I had to #include <scsi/scsi.h> to get SCSI_2 for the
> Hugh> build somewhere (and a SCSI_2 seems to be worth 1 more than
> Hugh> anyone else's 2), then it worked just fine for me thanks.
> 
> The DIF drives in question claim rev. 3 and are configured correctly
> with James' patch in place.
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

OK, so this is the solution until we get USB devices claiming SCSI-3 and
mucking with the protection bit ...

James



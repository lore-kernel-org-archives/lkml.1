Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbZASI6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbZASI6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 03:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbZASI62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 03:58:28 -0500
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:35070 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754544AbZASI61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 03:58:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eK51cFCRYD5GbLsZchLXv+ue1VMDNfH1ITx4yh4vPyVMMUiMnaxDg/gAWGU1JP/4dZUzg+0JwDwUkeGqRop5yCk6bSeUoP/TKd/kkxLcEKtbIENPhA4o4U6fCb1lBosvXLkaVAGYcdii8E05wI1HO5AyBq5S3wk6g0BOrd52OwA=  ;
X-YMail-OSG: S66szLIVM1kSikTrY2jg8XJP4BpOKysxkKdS.oEtZ9v9GVyU0OCkkkdGlG2Om1w.EofLDG7JS1WBju._vmrJaJoUg5c9RHPuUWVwqj94kSFgZD6gJsIK5JRLXyDUa3Sl0HifGSBMA5FmjybFENU0s2dZsYI57Gmb4xrBxEUeY_LcoVsvp1pL4etjTkjI1EbbBAwuh75EQWutQYY7546LFVxmZG_9PVGlI6w-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: Mainline kernel OLTP performance update
Date: Mon, 19 Jan 2009 19:57:56 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: "Matthew Wilcox" <matthew@wil.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       "Andrew Vasquez" <andrew.vasquez@qlogic.com>,
       "Anirban Chakraborty" <anirban.chakraborty@qlogic.com>,
       "Christoph Lameter" <cl@linux-foundation.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <200901191942.48548.nickpiggin@yahoo.com.au> <84144f020901190047v1f7f6710l5d4af50b57be3a7e@mail.gmail.com>
In-Reply-To: <84144f020901190047v1f7f6710l5d4af50b57be3a7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901191957.57703.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009 19:47:24 Pekka Enberg wrote:
> On Mon, Jan 19, 2009 at 10:42 AM, Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > Anyway, nobody has disagreed with my proposal to merge SLQB, so in the
> > worst case I don't think it will cause too much harm, and in the best
> > case it might turn out to make the best tradeoffs and who knows, it
> > might actually not be catastrophic for HPC ;)
>
> Yeah. If Andrew/Linus doesn't want to merge SLQB to 2.6.29, we can

I would prefer not. Apart from not practicing what I preach about
merging, if it has stupid bugs on some systems or obvious performance
problems, it will not be a good start ;)

> stick it in linux-next through slab.git if you want.

That would be appreciated. It's not quite ready yet...

Thanks.
Nick


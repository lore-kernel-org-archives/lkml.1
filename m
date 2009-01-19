Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbZASIrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbZASIrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 03:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZASIr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 03:47:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:61510 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZASIr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 03:47:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=be+CYLKsVuUF0SIXUOX16YZ0CiJ7b8x5PzlDVzfrCbbVCAwEcTWIDboBKVrP/Ux6sH
         bY9WgLx1S8VcFcQxjKrR41E1/TSIeiynLKh58lVt3wIBVfIqdblBwppKII6kIt8Jvu1B
         2faAITmGfFc3/a4UrtJg+PI6gIFYivKRnGAls=
Message-ID: <84144f020901190047v1f7f6710l5d4af50b57be3a7e@mail.gmail.com>
Date: Mon, 19 Jan 2009 10:47:24 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: Mainline kernel OLTP performance update
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
In-Reply-To: <200901191942.48548.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <1232352303.30141.25.camel@penberg-laptop>
	 <200901191933.29322.nickpiggin@yahoo.com.au>
	 <200901191942.48548.nickpiggin@yahoo.com.au>
X-Google-Sender-Auth: 2412107b65ea1179
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 10:42 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Anyway, nobody has disagreed with my proposal to merge SLQB, so in the
> worst case I don't think it will cause too much harm, and in the best
> case it might turn out to make the best tradeoffs and who knows, it
> might actually not be catastrophic for HPC ;)

Yeah. If Andrew/Linus doesn't want to merge SLQB to 2.6.29, we can
stick it in linux-next through slab.git if you want.

                                Pekka

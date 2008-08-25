Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbYHYUWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbYHYUWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYHYUWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:22:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:29720 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYHYUWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=e9zqb4f37oE/iZnkscH64IjGBBjHn15omweNBNmRvXR69DH+XFd79uPbaGcGv70M91
         C/maW1AWRYByfR9QpAeu7tBeNRal0VpB+mwLQktaD28rhTYiS/3MGHKAUtnQ+S81CPNN
         TtBFE0KLQU/EZSDFrKC/ejruIitk5gEVRmuEI=
Message-ID: <86802c440808251322l72546d59o90c4e0b87c81538c@mail.gmail.com>
Date: Mon, 25 Aug 2008 13:22:10 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alexander Huemer" <alexander.huemer@sbg.ac.at>
Subject: Re: 2.6.27 mtrr fixes do not work when X starts
Cc: "Helge Hafting" <helge.hafting@aitel.hist.no>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <48B313C3.30704@sbg.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4899AF8E.20105@sbg.ac.at> <48A43CB5.8010709@sbg.ac.at>
	 <86802c440808141031p2712976cqe2c34d3b986ad810@mail.gmail.com>
	 <48AD8125.7050104@sbg.ac.at>
	 <86802c440808210827y72bb1ec0ndcb97b00d6af3a9c@mail.gmail.com>
	 <48AE90BB.5090800@aitel.hist.no>
	 <86802c440808221024u1f152a73hf060f70e1b16dccb@mail.gmail.com>
	 <48B29320.5070903@aitel.hist.no>
	 <86802c440808251308i609a1c8ay6a7300bf4d0e0758@mail.gmail.com>
	 <48B313C3.30704@sbg.ac.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 1:19 PM, Alexander Huemer
<alexander.huemer@sbg.ac.at> wrote:
> Yinghai Lu wrote:

> should i try that boot option too?
> can i try anything else?
> i hope you remember my emails.

your case is different. it seems the whole mtrr_cleanup is not
triggered anyway...
you may try tip/master, and send out you .confg

YH

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZBGVUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZBGVUk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 16:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZBGVUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 16:20:12 -0500
Received: from mail.crca.org.au ([67.207.131.56]:41353 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbZBGVUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 16:20:11 -0500
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH 3/3][RFC] swsusp: shrink file cache first
From: Nigel Cunningham <ncunningham-lkml@crca.org.au>
Reply-To: ncunningham-lkml@crca.org.au
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, rjw@sisk.pl, riel@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <2f11576a0902070851q7d478679i8a47ad9b3810dc0e@mail.gmail.com>
References: <20090206031125.693559239@cmpxchg.org>
	 <20090206031324.004715023@cmpxchg.org>
	 <20090206122129.79CC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090206044907.GA18467@cmpxchg.org>
	 <20090206130009.99400d43.akpm@linux-foundation.org>
	 <2f11576a0902070851q7d478679i8a47ad9b3810dc0e@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 08 Feb 2009 08:20:51 +1100
Message-Id: <1234041651.7277.5.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, 2009-02-08 at 01:51 +0900, KOSAKI Motohiro wrote:
> akpm wrote:
> --------------
>  And what was the observed effect of all this?
> 
> Rafael wrote:
> --------------
> Measurable effects:
> 1) It tends to free only as much memory as required, eg. if the image_size
> is set to 450 MB, the actual image sizes are almost always well above
> 400 MB and they tended to be below that number without the patch
> (~5-10% of a difference, but still :-)).

Do you always get at least the number of pages you ask for, if that's
possible?

Regards,

Nigel


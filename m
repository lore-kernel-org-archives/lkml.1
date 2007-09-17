Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbXIQSrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbXIQSrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbXIQSqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:46:01 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47639 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759055AbXIQSp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:45:59 -0400
Message-ID: <46EEC978.9080303@sgi.com>
Date: Mon, 17 Sep 2007 11:37:44 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Ethan Solomita <solo@google.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1/6] cpuset write dirty map
References: <469D3342.3080405@google.com> <46E741B1.4030100@google.com>	 <46E742A2.9040006@google.com>	 <20070914161536.3ec5c533.akpm@linux-foundation.org>	 <a781481a0709141647q3d019423s388c64bf6bed871a@mail.gmail.com>	 <20070914170733.dbe89493.akpm@linux-foundation.org> <a781481a0709141716n569d54eeqbe51746d3a5110ca@mail.gmail.com>
In-Reply-To: <a781481a0709141716n569d54eeqbe51746d3a5110ca@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
 > True, the other option could be to put the /pointer/ in there unconditionally,
> but that would slow down the MAX_NUMNODES <= BITS_PER_LONG case,
> which (after grepping through defconfigs) appears to be the common case on
> all archs other than ia64. So I think your idea of making that conditional
> centralized in the code with an accompanying comment is the way to go here ...

It won't be long before arch's other than ia64 will have
MAX_NUMNODES > BITS_PER_LONG. While it won't be the norm,
we should account for it now.

Thanks,
Mike

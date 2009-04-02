Return-Path: <linux-kernel-owner+w=401wt.eu-S935424AbZDBHYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935424AbZDBHYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935251AbZDBHYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:24:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34350 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765360AbZDBHYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:24:23 -0400
Message-ID: <49D46841.8080908@redhat.com>
Date: Thu, 02 Apr 2009 10:24:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Chris Wright <chrisw@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, riel@redhat.com,
       jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net,
       yaniv@redhat.com, dmonakhov@openvz.org
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
References: <49D20B63.8020709@redhat.com> <49D21B33.4070406@codemonkey.ws> <20090331142533.GR9137@random.random> <49D22A9D.4050403@codemonkey.ws> <20090331150218.GS9137@random.random> <49D23224.9000903@codemonkey.ws> <20090331151845.GT9137@random.random> <49D23CD1.9090208@codemonkey.ws> <20090331162525.GU9137@random.random> <49D24A02.6070000@codemonkey.ws> <20090402012215.GE1117@x200.localdomain> <49D424AF.3090806@codemonkey.ws>
In-Reply-To: <49D424AF.3090806@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
>
> I'm often afraid of what sort of bugs we'd uncover in kvm if we passed 
> the fds around via SCM_RIGHTS and started poking around :-/

kvm checks the mm doesn't change underneath.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


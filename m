Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbYKFQ6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbYKFQ6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750804AbYKFQ57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:57:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35943 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbYKFQ57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:57:59 -0500
Message-ID: <491321ED.5010103@redhat.com>
Date: Thu, 06 Nov 2008 11:57:17 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
References: <20081106153022.215696930@redhat.com>	 <1225986593.7803.4688.camel@twins> <20081106160154.GA7461@redhat.com>	 <1225988173.7803.4723.camel@twins>  <20081106163957.GB7461@redhat.com> <1225990327.7803.4776.camel@twins>
In-Reply-To: <1225990327.7803.4776.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> The only real issue I can see is with linear volumes, but those are
> stupid anyway - non of the gains but all the risks.

Linear volumes may well be the most common ones.

People start out with the filesystems at a certain size,
increasing onto a second (new) disk later, when more space
is required.

-- 
All rights reversed.

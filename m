Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbZKARwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbZKARwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 12:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbZKARwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 12:52:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbZKARwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 12:52:21 -0500
Message-ID: <4AEDCAA6.8050301@redhat.com>
Date: Sun, 01 Nov 2009 12:51:34 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCHv2 3/5] vmscan: Stop zone_reclaim()'s wrong swap_cluster_max
 usage
References: <20091101234614.F401.A69D9226@jp.fujitsu.com> <20091102000951.F407.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091102000951.F407.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2009 10:11 AM, KOSAKI Motohiro wrote:
> In old days, we didn't have sc.nr_to_reclaim and it brought
> sc.swap_cluster_max misuse.
>
> huge sc.swap_cluster_max might makes unnecessary OOM and
> no performance benefit.
>
> Now, we can remove above dangerous one.
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.

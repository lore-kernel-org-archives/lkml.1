Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbZKBAmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbZKBAmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 19:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbZKBAmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 19:42:44 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52984 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZKBAmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 19:42:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=a1ZSNTngGaKh4aJyYPNh17N2Qdzdj/77XjzRxmae+9QC87N6DA1aGezD8kyUaKRBMN
         lJKQQrtfKOm6TI0UGSsaqRJZl25xpmcQbCDxVyQdzX6OVmrSQeNPLjyyK5Y5/JHCtrco
         A1bLxs6cY9Q23df8LL3eY1nbMAidBKafIqMqA=
Date: Mon, 2 Nov 2009 09:40:12 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCHv2 3/5] vmscan: Stop zone_reclaim()'s wrong
 swap_cluster_max usage
Message-Id: <20091102094012.8a8fc5c8.minchan.kim@barrios-desktop>
In-Reply-To: <20091102000951.F407.A69D9226@jp.fujitsu.com>
References: <20091101234614.F401.A69D9226@jp.fujitsu.com>
	<20091102000951.F407.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009 00:11:02 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> In old days, we didn't have sc.nr_to_reclaim and it brought
> sc.swap_cluster_max misuse.
> 
> huge sc.swap_cluster_max might makes unnecessary OOM and
> no performance benefit.
> 
> Now, we can remove above dangerous one.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim

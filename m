Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab0BULuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 06:50:44 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34943 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab0BULun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 06:50:43 -0500
Date: Sun, 21 Feb 2010 20:50:02 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] mm: Document /sys/devices/system/node/nodeX
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-mm@kvack.org, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100220094109.GJ1445@csn.ul.ie>
References: <20100220094109.GJ1445@csn.ul.ie>
Message-Id: <20100221204641.B810.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add a bare description of what /sys/devices/system/node/nodeX is. Others
> will follow in time but right now, none of that tree is documented. The
> existence of this file might at least encourage people to document new entries.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Sure. 
/sys/devices/system/node/nodeX have many frequently used knob and stat and
it live in for long time. It is obviously ABI.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> ---
>  Documentation/ABI/stable/sysfs-devices-node |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/stable/sysfs-devices-node
> 
> diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
> new file mode 100644
> index 0000000..49b82ca
> --- /dev/null
> +++ b/Documentation/ABI/stable/sysfs-devices-node
> @@ -0,0 +1,7 @@
> +What:		/sys/devices/system/node/nodeX
> +Date:		October 2002
> +Contact:	Linux Memory Management list <linux-mm@kvack.org>
> +Description:
> +		When CONFIG_NUMA is enabled, this is a directory containing
> +		information on node X such as what CPUs are local to the
> +		node.
> -- 
> 1.6.5
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>




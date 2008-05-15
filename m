Return-Path: <linux-kernel-owner+w=401wt.eu-S1760372AbYEORhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760372AbYEORhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYEORhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:37:43 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2434 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYEORhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:37:42 -0400
Date: Thu, 15 May 2008 18:37:37 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@osdl.org>, Christoph Lameter <clameter@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] slob: record page flag overlays explicitly
Message-ID: <20080515173737.GA21787@shadowen.org>
References: <exportbomb.1210871946@pinky> <1210872010.0@pinky>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210872010.0@pinky>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 06:20:10PM +0100, Andy Whitcroft wrote:

>  static inline void clear_slob_page(struct slob_page *sp)
>  {
> -	__clear_bit(PG_active, &sp->flags);
> +	__clear_bit(PG_slob_free, &sp->flags);
>  }

Bah, this hunk is wrong.  Seems this is not the latest version.  Will
replace this patch momentarily.

-apw

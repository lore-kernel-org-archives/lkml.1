Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbYEZEja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbYEZEja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 00:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbYEZEjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 00:39:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59807 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbYEZEjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 00:39:20 -0400
Date: Mon, 26 May 2008 13:37:51 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 1/3] page-flags: record page flag overlays explicitly
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       Andrew Morton <akpm@osdl.org>, Christoph Lameter <clameter@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1211560392.0@pinky>
References: <exportbomb.1211560342@pinky> <1211560392.0@pinky>
Message-Id: <20080526132853.4661.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thank you nice patch.

> Some page flags are used for more than one purpose, for example
> PG_owner_priv_1.  Currently there are individual accessors for each user,
> each built using the common flag name far away from the bit definitions.
> This makes it hard to see all possible uses of these bits.
> 
> Now that we have a single enum to generate the bit orders it makes sense
> to express overlays in the same place.  So create per use aliases for
> this bit in the main page-flags enum and use those in the accessors.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>

My review found no bug.

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




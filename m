Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbYCJVSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbYCJVSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYCJVSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:18:36 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:38301
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbYCJVSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:18:36 -0400
Message-ID: <47D5B391.6040309@microgate.com>
Date: Mon, 10 Mar 2008 16:17:53 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] synclink drivers bool conversion
References: <1205046574.656.37.camel@localhost>	 <47D3FCF6.70908@microgate.com>  <1205092170.656.59.camel@localhost>	 <1205114703.656.115.camel@localhost>  <47D5A793.9070105@microgate.com> <1205183029.656.170.camel@localhost>
In-Reply-To: <1205183029.656.170.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
>  include/linux/synclink.h          |    4 -
>  drivers/char/pcmcia/synclink_cs.c |  125 +++++++++---------
>  drivers/char/synclink.c           |  258 ++++++++++++++++++-------------------
>  drivers/char/synclink_gt.c        |  102 ++++++++--------
>  drivers/char/synclinkmp.c         |  157 +++++++++++-----------
>  5 files changed, 319 insertions(+), 327 deletions(-)

Acked-by: Paul Fulghum <paulkf@microgate.com>

Andrew, Here is Joe's original patch description:

Remove more TRUE/FALSE defines and uses
Remove == TRUE tests
Convert BOOLEAN to bool
Convert int to bool where appropriate


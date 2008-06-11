Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYFKHbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYFKHbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 03:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYFKHbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 03:31:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:17619 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbYFKHbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 03:31:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=QOSD7/lro/1I5eN1VNcxCRTHBKAId3iuzQP5rVtlY/SZuGkSYeHfotpJGotQHr3v1e
         Aq3KPxUhsU752gAzjv8bzwtroWnDhEmY4R4abzMxYafTVGMrlu57JHgwKWP+iwQPoKKj
         ye647sLbYZfbTTrSLafjgF8LXVuQSHgNrViv8=
Date: Wed, 11 Jun 2008 09:31:01 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au, Rik van Riel <riel@redhat.com>
Subject: Re: 2.6.26-rc5-mm2: OOM with 1G free swap
Message-ID: <20080611073101.GA3591@slug>
References: <20080611060029.GA5011@martell.zuzino.mipt.ru> <20080610232705.3aaf5c06.akpm@linux-foundation.org> <20080611153457.7882.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611153457.7882.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 11, 2008 at 03:36:40PM +0900, KOSAKI Motohiro wrote:
> > > vm.overcommit_memory = 0
> > > vm.overcommit_ratio = 50
> > 
> > Well I assume that Rik ran LTP.  Perhaps a merge problem.
> 
> at least, I ran LTP last week and its error didn't happend.
> I'll investigate more.
FWIW, I can reproduce it reliably:
$ cd <ltp-dir>/testcases/bin
$ ./growfiles -W gf15 -b -e 1 -u -r 1-49600 -I r -u -i 0 -L 120 Lgfile1
And then wait for a few secs before the OOM triggers.

Regards,
Frederik

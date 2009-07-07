Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbZGGCb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbZGGCb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 22:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZGGCbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 22:31:21 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:58655 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbZGGCbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 22:31:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=CMnjGQvsFEcp/0zW9NmqkNtbP+kpNDDAKRZwJSuHUVNuByacjE95e7/SAwSKQvmMh7
         61gEc5MCLDfPd122k7gq3RyCOKRSUd6ctOHorP0Roc28jJS3+jNyDPzVi9uuSlZyoGiu
         Yt3GHYKdQxAgKO1vnrQqno7o3mLLYWnslAfIw=
Date: Tue, 7 Jul 2009 11:31:13 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
Message-Id: <20090707113113.84cf1347.minchan.kim@barrios-desktop>
In-Reply-To: <20090707111030.0C69.A69D9226@jp.fujitsu.com>
References: <20090707101855.0C63.A69D9226@jp.fujitsu.com>
	<20090707104806.6706ac4a.minchan.kim@barrios-desktop>
	<20090707111030.0C69.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Jul 2009 11:12:33 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > It looks good to me. 
> > Thanks for your effort. I added my review sign. :)
> > 
> > Let remain one side note. 
> > This accounting feature results from direct reclaim bomb. 
> > If we prevent direct reclaim bomb, I think this feature can be removed. 
> 
> Hmmm. I disagree.
> isolated pages can become more than >1GB on server systems.
> Who want >1GB unaccountable memory?

I am okay if it happens without reclaim bomb on server system which 
have a lot of memory as you said.  

-- 
Kind regards,
Minchan Kim

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0BSB4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 20:56:42 -0500
Received: from mail-pz0-f192.google.com ([209.85.222.192]:39335 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab0BSB4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 20:56:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Om+PZmtRZAqXd5vrAAxEJ3tSyfVc94HhWYRtMGQDKKjd6GzeBbNh4EgXJI4vTMUlUQ
         xrIcUMtYEhObzhPJSjS3rrEmLZZbmMqmCYpptoofBYAIGu9mVnINUWdzJiHPOKhbNcUM
         gYVkeXIzq/XsfrLqhJCLmX1m4ylRuEcUMgXSc=
MIME-Version: 1.0
In-Reply-To: <1265976059-7459-7-git-send-email-mel@csn.ul.ie>
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie>
	 <1265976059-7459-7-git-send-email-mel@csn.ul.ie>
Date: Fri, 19 Feb 2010 10:56:40 +0900
Message-ID: <28c262361002181756i3dc430bdtdc506b54362a40ce@mail.gmail.com>
Subject: Re: [PATCH 06/12] Add /proc trigger for memory compaction
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 9:00 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> This patch adds a proc file /proc/sys/vm/compact_memory. When an arbitrary
> value is written to the file, all zones are compacted. The expected user
> of such a trigger is a job scheduler that prepares the system before the
> target application runs.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim>

-- 
Kind regards,
Minchan Kim

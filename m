Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbYJPQZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbYJPQZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 12:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbYJPQZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 12:25:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:16156 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbYJPQZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:25:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=C3isjdhcbEvEpRqv9vYfdj4paohHWrD8oRQf+tJCyh7V08ilObMWPyVwQ/zgX+3Yfh
         BfZLsMB+QDYtmsIHXGlLmZf8OVmf89Uc/493/oEJaORrj1ulfFi4vJEfrOyk77sMqFn6
         mI567hQE2DJI+IZw48PU2bkGhj7S1E0rjU55c=
Message-ID: <2f11576a0810160925u3fa9c206k58226eebfe096113@mail.gmail.com>
Date: Fri, 17 Oct 2008 01:25:49 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Mel Gorman" <mel@csn.ul.ie>
Subject: Re: [PATCH 1/2] Subject: [PATCH] Report the pagesize backing a VMA in /proc/pid/smaps
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Dave Hansen" <dave@linux.vnet.ibm.com>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1224172715-17667-2-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1224172715-17667-1-git-send-email-mel@csn.ul.ie>
	 <1224172715-17667-2-git-send-email-mel@csn.ul.ie>
X-Google-Sender-Auth: d5a548ba4aa46909
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> It is useful to verify a hugepage-aware application is using the expected
> pagesizes for its memory regions. This patch creates an entry called
> KernelPageSize in /proc/pid/smaps that is the size of page used by the
> kernel to back a VMA. The entry is not called PageSize as it is possible
> the MMU uses a different size. This extension should not break any sensible
> parser that skips lines containing unrecognised information.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

ack.

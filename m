Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbZBWH3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbZBWH3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 02:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZBWH3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 02:29:04 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:44810 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbZBWH3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 02:29:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=smICxLnXkFCX58+v7KmRKATT/hmBQO0uXaKqwJqxa7YLJuvQ+kR1il+wKEJ7iZZN0Y
         za8CDYwVJ7PrbGcaZIu1QgNMK71BaTk6Mn5MXZPKD+DjGctSthD/XangxsAusCg6NuWX
         bk9zTHNR7EMCkI+PuziLqjOcEcNwNRZw3/HGw=
MIME-Version: 1.0
In-Reply-To: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
Date: Mon, 23 Feb 2009 09:29:00 +0200
X-Google-Sender-Auth: c9ede8e50b005127
Message-ID: <84144f020902222329u5754f8b1k790809191ac48f4a@mail.gmail.com>
Subject: Re: [RFC PATCH 00/20] Cleanup and optimise the page allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 1:17 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> The complexity of the page allocator has been increasing for some time
> and it has now reached the point where the SLUB allocator is doing strange
> tricks to avoid the page allocator. This is obviously bad as it may encourage
> other subsystems to try avoiding the page allocator as well.

I'm not an expert on the page allocator but the series looks sane to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Yanmin, it would be interesting to know if we still need 8K kmalloc
caches with these patches applied. :-)

                               Pekka

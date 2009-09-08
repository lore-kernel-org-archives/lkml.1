Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbZIHRK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbZIHRK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZIHRK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:10:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbZIHRKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:10:25 -0400
Message-ID: <4AA68FEB.6090703@redhat.com>
Date: Tue, 08 Sep 2009 13:10:03 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Hiroaki Wakabayashi <primulaelatior@gmail.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 1/8] mm: munlock use follow_page
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils> <Pine.LNX.4.64.0909072227140.15430@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909072227140.15430@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Hiroaki Wakabayashi points out that when mlock() has been interrupted
> by SIGKILL, the subsequent munlock() takes unnecessarily long because
> its use of __get_user_pages() insists on faulting in all the pages
> which mlock() never reached.

> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Nice cleanup.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.

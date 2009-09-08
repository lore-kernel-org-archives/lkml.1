Return-Path: <linux-kernel-owner+w=401wt.eu-S1751923AbZIHR1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbZIHR1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZIHR1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:27:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbZIHR1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:27:45 -0400
Message-ID: <4AA69405.3080403@redhat.com>
Date: Tue, 08 Sep 2009 13:27:33 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/8] mm: remove unused GUP flags
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils> <Pine.LNX.4.64.0909072230010.15430@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909072230010.15430@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> GUP_FLAGS_IGNORE_VMA_PERMISSIONS and GUP_FLAGS_IGNORE_SIGKILL were
> flags added solely to prevent __get_user_pages() from doing some of
> what it usually does, in the munlock case: we can now remove them.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.

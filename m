Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbZLNOs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbZLNOs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbZLNOsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:48:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585AbZLNOsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:48:54 -0500
Message-ID: <4B265028.4080808@redhat.com>
Date: Mon, 14 Dec 2009 09:48:08 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: lwoodman@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH 8/8] mm: Give up allocation if the task have fatal signal
References: <20091211164651.036f5340@annuminas.surriel.com> <20091214210823.BBAE.A69D9226@jp.fujitsu.com> <20091214213224.BBC6.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091214213224.BBC6.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2009 07:32 AM, KOSAKI Motohiro wrote:
> In OOM case, almost processes may be in vmscan. There isn't any reason
> the killed process continue allocation. process exiting free lots pages
> rather than greedy vmscan.
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab0BTAQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:16:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab0BTAQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:16:48 -0500
Message-ID: <4B7F29CD.1050703@redhat.com>
Date: Fri, 19 Feb 2010 19:16:13 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 03/12] mm: Share the anon_vma ref counts between KSM	and
 page migration
References: <1266516162-14154-1-git-send-email-mel@csn.ul.ie> <1266516162-14154-4-git-send-email-mel@csn.ul.ie> <4B7F05BA.4080903@redhat.com> <20100219215826.GF1445@csn.ul.ie>
In-Reply-To: <20100219215826.GF1445@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2010 04:58 PM, Mel Gorman wrote:

> external_refcount is about as good as I can think of to explain what's
> going on :/

Sounds "good" to me.  Much better than giving the wrong
impression that this is the only refcount for the anon_vma.

-- 
All rights reversed.

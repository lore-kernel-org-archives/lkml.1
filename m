Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab0CEOLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 09:11:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab0CEOLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 09:11:08 -0500
Message-ID: <4B9110ED.5000703@redhat.com>
Date: Fri, 05 Mar 2010 09:10:53 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Christian Ehrhardt <lk@c--e.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] rmap: Fix Bugzilla Bug #5493
References: <20100305093834.GG17078@lisa.in-ulm.de>
In-Reply-To: <20100305093834.GG17078@lisa.in-ulm.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2010 04:38 AM, Christian Ehrhardt wrote:
>
> Hi,
>
> this patch fixes bugzilla Bug
>
>          http://bugzilla.kernel.org/show_bug.cgi?id=5493
>
> This bug describes a search complexity failure in rmap if a single
> anon_vma has a huge number of vmas associated with it.
>
> The patch makes the vma prio tree code somewhat more reusable and then uses
> that to replace the linked list of vmas in an anon_vma with a prio_tree.

Your patch will not apply against a current -mm, because it
conflicts with my anon_vma linking patches (which attacks
another "rmap walks too many vmas" failure mode).

Please rediff your patch against the latest -mm tree.

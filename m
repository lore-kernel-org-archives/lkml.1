Return-Path: <linux-kernel-owner+w=401wt.eu-S934026AbZDBQ6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026AbZDBQ6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760132AbZDBQ6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:58:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755123AbZDBQ6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:58:40 -0400
Date: Thu, 2 Apr 2009 09:53:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH]  Define a UNIQUE value for AS_UNEVICTABLE flag
Message-Id: <20090402095315.1098b6c3.akpm@linux-foundation.org>
In-Reply-To: <1238690835.7359.16.camel@lts-notebook>
References: <1238690835.7359.16.camel@lts-notebook>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Apr 2009 12:47:15 -0400 Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> [PATCH] Define UNIQUE value of AS_UNEVICTABLE
> 
> Needed in 2.6.28, 2.6.29, ...
> 
> A new "address_space flag"--AS_MM_ALL_LOCKS--was defined to use the next
> available AS flag while the Unevictable LRU was under development.  The
> Unevictable LRU was using the same flag and "no one" noticed.  Current 
> mainline, since 2.6.28, has same value for two symbolic flag names.

argh.

What are the user-observable effects of the bug, and why didn't anyone
notice it until now?


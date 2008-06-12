Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbYFLRKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbYFLRKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYFLRKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:10:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbYFLRKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:10:43 -0400
Date: Thu, 12 Jun 2008 13:10:34 -0400
From: Rik van Riel <riel@redhat.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Message-ID: <20080612131034.4d8f6301@cuia.bos.redhat.com>
In-Reply-To: <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	<20080612093833.0fb9cdd6@bree.surriel.com>
	<1213278884.3936.15.camel@johannes.berg>
	<1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 18:43:37 +0300
"Tomas Winkler" <tomasw@gmail.com> wrote:

> This is scatter gather buffers that can be kicked in one DMA transaction.

> This I still don't understand why but everybody is already tired to
> explaining me why.. :) Just need to find time to dig into it.

The only thing that makes no sense to me is why your
driver "needs" to allocate 10x as much memory in that
buffer than it will ever use.

What is the problem with the simpler solution, which
just reduces the size of the buffer to an amount of
memory that might actually get used?

-- 
All Rights Reversed

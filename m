Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbXGWVRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbXGWVRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbXGWVRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:17:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47042 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbXGWVRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:17:12 -0400
Date: Mon, 23 Jul 2007 14:16:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: will_schmidt@vnet.ibm.com
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH respin, was PATCH for review] During VM oom condition,
 kill all threads in process group
Message-Id: <20070723141641.5759a287.akpm@linux-foundation.org>
In-Reply-To: <1185214185.22237.30.camel@farscape.rchland.ibm.com>
References: <20070719348.540885000@suse.de>
	<20070719134840.47B5114E6E@wotan.suse.de>
	<20070719140411.GD16279@infradead.org>
	<Pine.LNX.4.64.0707191614180.7377@anakin>
	<1185214185.22237.30.camel@farscape.rchland.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 13:09:45 -0500
Will Schmidt <will_schmidt@vnet.ibm.com> wrote:

> During VM oom condition, kill all threads in process group.
> 
> We have had complaints where a threaded application is left in a bad
> state after one of it's threads is killed when we hit a VM: out_of_memory
> condition.
> Killing just one of the process threads can leave the application in a
> bad state, whereas killing the entire process group would allow for
> the application to restart, or be otherwise handled, and makes it very
> obvious that something has gone wrong.
> 
> This change allows the entire process group to be taken down, rather
> than just the one thread.

Just checking...

blackfin
h8300
m68knommu
uml
v850

were not changed.  Intentional?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbYHDCjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbYHDCjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759190AbYHDChp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:37:45 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:33006 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761788AbYHDChn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:37:43 -0400
Message-ID: <48966B6D.604@keyaccess.nl>
Date: Mon, 04 Aug 2008 04:37:33 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Matthew Wilcox <matthew@wil.cx>,
       Christoph Lameter <cl@linux-foundation.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080801182324.572058187@lameter.com> <20080803015847.GD26461@parisc-linux.org> <4896225D.9090203@cs.helsinki.fi>
In-Reply-To: <4896225D.9090203@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03-08-08 23:25, Pekka Enberg wrote:

> Matthew Wilcox wrote:

>> Do we have to once again explain that slab still outperforms slub on at
>> least one important benchmark?  I hope Nick Piggin finds time to finish
>> tuning slqb; it already outperforms slub.
> 
> No, you don't have to. I haven't merged that patch nor do I intend to do 
> so until the regressions are fixed.
> 
> And yes, I'm still waiting to hear from you how we're now doing with 
> higher order page allocations...

General interested question -- I recently "accidentally" read some of 
slub and I believe that it doesn't feature the cache colouring support 
that slab did? Is that true, and if so, wasn't it needed/useful?

Rene.

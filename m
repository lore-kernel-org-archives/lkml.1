Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbYE1U2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbYE1U2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 16:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbYE1U1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 16:27:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33866 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbYE1U1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 16:27:52 -0400
Message-ID: <483DBFC3.1070108@cs.helsinki.fi>
Date: Wed, 28 May 2008 23:25:39 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>,
       cooloney@kernel.org, akpm@linux-foundation.org, dhowells@redhat.com,
       mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
References: <Pine.LNX.4.64.0805281646470.27125@sbz-30.cs.Helsinki.FI> <20080528153648.GA27783@linux-sh.org> <483DBA85.2060502@cs.helsinki.fi> <Pine.LNX.4.64.0805281325260.932@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805281325260.932@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
>> We use kobjsize() for pointers returned from do_mmap() which is why I kept the
>> page->index case. Are we using PageCompound for those as well?
> 
> What does do_mmap have to do with page->index?

I don't know how the nommu code is supposed to work. I simply assumed it 
has a reason for being there and that compound_order() is not enough to 
handle that.

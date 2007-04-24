Return-Path: <linux-kernel-owner+w=401wt.eu-S1161486AbXDXCY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161486AbXDXCY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 22:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161492AbXDXCY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 22:24:56 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161486AbXDXCYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 22:24:55 -0400
Date: Mon, 23 Apr 2007 19:24:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: Remove open coded implementations of memclear_highpage flush
Message-Id: <20070423192437.b159a851.akpm@linux-foundation.org>
In-Reply-To: <a781481a0704231919s584e55bfv99f45132b6f191c@mail.gmail.com>
References: <Pine.LNX.4.64.0704231547080.975@schroedinger.engr.sgi.com>
	<a781481a0704231919s584e55bfv99f45132b6f191c@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 07:49:45 +0530 "Satyam Sharma" <satyam.sharma@gmail.com> wrote:

> On 4/24/07, Christoph Lameter <clameter@sgi.com> wrote:
> > There are a series of open coded reimplementation of memclear_highpage_flush
> > all over the page cache code. Call memclear_highpage_flush in those locations.
> > Consolidates code and eases maintenance.
> 
> If I remember right, a very similar patchset was recently submitted
> that Andrew merged in -mm(?).

yup.

> It also renamed memclear_highpage_flush
> to something like zero_user_page (though I wonder how good a name that
> is considering it takes an offset and not the whole page)

It's not a great name, but the fact that you must provide it with `offset'
and `length' arguments rather clears up any confusion ;)


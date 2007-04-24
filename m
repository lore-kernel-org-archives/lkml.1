Return-Path: <linux-kernel-owner+w=401wt.eu-S1161492AbXDXCZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161492AbXDXCZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 22:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161513AbXDXCZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 22:25:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57153 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161492AbXDXCZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 22:25:11 -0400
Date: Mon, 23 Apr 2007 19:25:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Remove open coded implementations of memclear_highpage flush
In-Reply-To: <a781481a0704231919s584e55bfv99f45132b6f191c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704231924390.4099@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231547080.975@schroedinger.engr.sgi.com>
 <a781481a0704231919s584e55bfv99f45132b6f191c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Satyam Sharma wrote:

> On 4/24/07, Christoph Lameter <clameter@sgi.com> wrote:
> > There are a series of open coded reimplementation of memclear_highpage_flush
> > all over the page cache code. Call memclear_highpage_flush in those
> > locations.
> > Consolidates code and eases maintenance.
> 
> If I remember right, a very similar patchset was recently submitted
> that Andrew merged in -mm(?). It also renamed memclear_highpage_flush
> to something like zero_user_page (though I wonder how good a name that
> is considering it takes an offset and not the whole page) and
> deprecated the old name.

My latest tree from Andrew does not have any of this. URL of patch?
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760861AbYGBH4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861AbYGBH4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 03:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYGBH4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 03:56:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbYGBH4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 03:56:23 -0400
Date: Wed, 2 Jul 2008 00:53:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       dmitry.torokhov@gmail.com, robfitz@273k.net, jikos@jikos.cz,
       vojtech@suse.cz, dmonakhov@openvz.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 001/002] linux-input:  bcm5974-0.31: fixed resource
 leak, removed work struct, device data struct introduced
Message-Id: <20080702005355.8da89ef7.akpm@linux-foundation.org>
In-Reply-To: <1214984799.11086.6.camel@alnilam>
References: <1214653629.10495.11.camel@alnilam>
	<20080701155925.a4c00a8e.akpm@linux-foundation.org>
	<1214984799.11086.6.camel@alnilam>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2008 09:46:39 +0200 Henrik Rydberg <rydberg@euromail.se> wrote:

> On Tue, 2008-07-01 at 15:59 -0700, Andrew Morton wrote:
> > > Subject: [PATCH 001/002] linux-input:  bcm5974-0.31: fixed resource leak, removed work struct, device data struct introduced
> > 
> > hm, I wonder where [002/002] went.
> 
> Thank you very much for your comments, I will return shortly with a new
> version. I did not fully grasp, from reading
> Documentation/SubmitPatches, how the numbering in the subject should
> work; when I submit my new version in reply to your mail, should I
> submit a complete patch against the vanilla kernel, with number 001/003?
> 

no....

The sequence numbering is only used when you're sending two or more
patches at the same time.  It is used so that the recipient can work
out what order they are to be applied in (they can get reordered in
flight) and so that the recipient can verify that none were missed.

So for a single patch, don't include it at all.

Also, it is better to prepare 2.6.27 patches against linux-next, as
that is the candidate 2.6.27 tree.  But in the case of a brand new
driver it doesn't matter a lot.  Unless you're using some interface
which we've gone and changed, but that's fairly uncommon.


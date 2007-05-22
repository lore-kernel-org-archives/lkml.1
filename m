Return-Path: <linux-kernel-owner+w=401wt.eu-S1762790AbXEVG2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762790AbXEVG2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 02:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758018AbXEVG2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 02:28:00 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:45832 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757052AbXEVG17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 02:27:59 -0400
Date: Tue, 22 May 2007 08:25:16 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
cc: Shaya Potter <spotter@cs.columbia.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH 10/14] In-kernel file copy between union mounted
 filesystems
In-Reply-To: <20070522031327.GA4728@in.ibm.com>
Message-ID: <Pine.LNX.4.61.0705220824320.4452@yvahk01.tjqt.qr>
References: <20070514093722.GB4139@in.ibm.com> <20070514094329.GL4139@in.ibm.com>
 <Pine.LNX.4.61.0705160951140.9570@yvahk01.tjqt.qr> <20070518111042.GC4869@in.ibm.com>
 <464DAE73.7000302@cs.columbia.edu> <20070522031327.GA4728@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 22 2007 08:43, Bharata B Rao wrote:
>On Fri, May 18, 2007 at 09:47:31AM -0400, Shaya Potter wrote:
>> Bharata B Rao wrote:
>> 
>> >
>> >Not really. This is called during copyup of a file residing in a lower
>> >layer. And that is done only for regular files.
>> 
>> That is broken.
>
>But it only breaks the semantics (in other cases we allow writes only to the
>top layer files). So the question is why do we have to copy up the device
>node ? What difference it makes to writing to the device itself ?

Because `chmod 666 blockdevnode` is not the same as writing
to the device itself?

>Currently we allow write to the device using the lower layer device node
>itself.


	Jan
-- 

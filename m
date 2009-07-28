Return-Path: <linux-kernel-owner+w=401wt.eu-S1751875AbZG1K1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbZG1K1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZG1K1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:27:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53174 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751181AbZG1K1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:27:39 -0400
Date: Tue, 28 Jul 2009 11:27:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org,
       Paul.Clements@steeleye.com, tytso@mit.edu, miklos <miklos@szeredi.hu>
Subject: Re: [PATCH] Allow userspace block device implementation
Message-ID: <20090728112734.5a75752d@lxorguk.ukuu.org.uk>
In-Reply-To: <4A6E764E.80805@redhat.com>
References: <4A6D79F6.3050509@redhat.com>
	<1248699365.6987.1628.camel@twins>
	<20090727142536.465799aa@lxorguk.ukuu.org.uk>
	<4A6E529B.9030104@kernel.org>
	<4A6E764E.80805@redhat.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW, implementing something like this via FUSE would be extremely
> unpleasant.  I'd need another layer on top, probably via the loop
> device, to get to the actual partitions of the block devices.

Use device mapper. Really we should shoot all the partition code in the
kernel but the back compatibility is a bit tricky. We don't actually need
the partition code any more.

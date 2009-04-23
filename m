Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbZDWMsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbZDWMsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbZDWMsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:48:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:32832 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621AbZDWMsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:48:42 -0400
Message-ID: <49F06381.3090605@garzik.org>
Date: Thu, 23 Apr 2009 08:48:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Jamie Lokier <jamie@shareable.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Valerie Aurora Henson <vaurora@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Eric Sandeen <sandeen@redhat.com>,
       Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC PATCH] fpathconf() for fsync() behavior
References: <20090423001257.GA16540@shell> <20090422221748.8c9022d1.akpm@linux-foundation.org> <20090423112105.GA1589@shareable.org> <20090423124230.GF2723@mit.edu>
In-Reply-To: <20090423124230.GF2723@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> So we can create a more finer-grained controlled system call ---
> although I would suggest that we just add some extra flags to
> sync_file_range() --- but it's doubtful that many application
> programmers will use it.

sync_file_range() seems the obvious avenue for new fsync flags.

I even explored what it would take to add a "flush storage dev writeback 
cache, for this file" flag to sync_file_range(), rather unfortunately 
non-trivial given the current implementation's close ties to MM.

But yeah...  how many people will use these fancy new flags and features?

	Jeff




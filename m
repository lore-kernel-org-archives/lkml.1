Return-Path: <linux-kernel-owner+w=401wt.eu-S933123AbZKXUNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123AbZKXUNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933131AbZKXUM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:12:58 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34692 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933084AbZKXUM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:12:56 -0500
Date: Tue, 24 Nov 2009 15:13:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jan Kara <jack@suse.cz>
cc: Boaz Harrosh <bharrosh@panasas.com>, <tmhikaru@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       <linux-ext4@vger.kernel.org>
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem
 readonly
In-Reply-To: <20091124195607.GC16662@quack.suse.cz>
Message-ID: <Pine.LNX.4.44L0.0911241510590.2881-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009, Jan Kara wrote:

>   After digging in block layer code, it's as we suspected:
> In case of host error DID_ERROR (which is our case), scsi request is
> retried iff it is not a FAILFAST request which is set if bio is doing
> readahead... So this is explained and everything behaves as it should.
> Thanks everybody involved :).

Okay, very good.  There remains the question of the disturbing error
messages in the system log.  Should they be supressed for FAILFAST
requests?

Alan Stern


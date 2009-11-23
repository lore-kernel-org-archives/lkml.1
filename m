Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZKWPF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZKWPF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZKWPF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:05:58 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42330 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752246AbZKWPF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:05:57 -0500
Date: Mon, 23 Nov 2009 10:06:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jan Kara <jack@suse.cz>
cc: tmhikaru@gmail.com, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
       <linux-scsi@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem
 readonly
In-Reply-To: <20091123105440.GB15679@duck.suse.cz>
Message-ID: <Pine.LNX.4.44L0.0911231004030.2958-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009, Jan Kara wrote:

>   Yeah, from what you write, it looks like USB enclosure is at fault (or it
> could still be your USB controller but I doubt it).  It's still a bit
> bothering that the error reported by the drive was not properly propagated
> up to VFS. Either it's some block layer retry/ignore magic that I missed or
> we ignore errors from block layer in some place.

Is there any interest in tracking this down?  It's not hard to find out
what low-level errors are being reported and to generate them on demand
with an emulated USB disk drive.

Alan Stern


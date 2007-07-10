Return-Path: <linux-kernel-owner+w=401wt.eu-S1762932AbXGJVh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762932AbXGJVh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 17:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759902AbXGJVhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 17:37:20 -0400
Received: from zakalwe.fi ([80.83.5.154]:45358 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759836AbXGJVhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 17:37:19 -0400
Date: Wed, 11 Jul 2007 00:37:01 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 1/7] manpage for fallocate
Message-ID: <20070710213701.GG3400@zakalwe.fi>
References: <20070710201200.GA10255@amitarora.in.ibm.com> <20070710201820.GA8797@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20070710201820.GA8797@amitarora.in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 01:48:20AM +0530, Amit K. Arora wrote:
> .BI "int syscall(int, int fd, int mode, loff_t offset, loff_t len);

Correction: "int syscall(int fd, int mode, ...)",

> .SH "ERRORS"
> .TP
> .B EBADF
> .I fd
> is not a valid file descriptor, or is not opened for writing.
> .TP
> .B EFBIG
> .I offset+len
> exceeds the maximum file size.
> .TP
> .B EINVAL
> .I offset
> or
> .I len
> was less than 0.
> .TP
> .B ENODEV
> .I fd
> does not refer to a regular file or a directory.
> .TP
> .B ENOSPC
> There is not enough space left on the device containing the file
> referred to by
> .IR fd.
> .TP
> .B ESPIPE
> .I fd
> refers to a pipe of file descriptor.
> .B ENOSYS
> The filesystem underlying the file descriptor does not support this
> operation.

EINTR?

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbZIXHKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbZIXHKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 03:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbZIXHKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 03:10:11 -0400
Received: from 1wt.eu ([62.212.114.60]:49203 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbZIXHKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 03:10:11 -0400
Date: Thu, 24 Sep 2009 09:10:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: KV Pavuram <kvpavuram@yahoo.co.in>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Socket vs File descriptor
Message-ID: <20090924071012.GD28315@1wt.eu>
References: <179773.9311.qm@web8404.mail.in.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179773.9311.qm@web8404.mail.in.yahoo.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 11:51:19PM -0700, KV Pavuram wrote:
> Hi,
> 
> Is there any  ioctl call to determine if a given descriptor is a file descriptor or a socket descriptor.
> 
> Similarly, is there a way to find out a socket descriptor type ie.e if it is SOCK_STREAM, or SOCK_DGRAM type.

You should look at getsockopt(), getsockname(), etc... I'm pretty
sure that one of those will offer you exactly what you need. Also,
look at the error codes. Sometimes you can rely on them because you
have different types depending on whether the FD you point to is
not a socket or is a socket of invalid type.

Regards,
Willy


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759071AbZBZXyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071AbZBZXyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 18:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbZBZXyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 18:54:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41915 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbZBZXyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 18:54:04 -0500
Date: Thu, 26 Feb 2009 23:54:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: filesystem time stamp resolution
Message-ID: <20090226235400.GP28946@ZenIV.linux.org.uk>
References: <49A7232C.6050808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A7232C.6050808@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 03:18:04PM -0800, Ulrich Drepper wrote:
> information.  E.g.:
> 
>   /proc/fs/ext4/timestamp-resolution
> 
> Measured in nano-seconds or so.

Who said that it's not going to be dependent on the flags used to
create and/or mount the filesystem?  IOW, what makes you think that
knowing fs type will be enough to derive that data from?

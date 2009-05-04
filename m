Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbZEDWYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbZEDWYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 18:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZEDWYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 18:24:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60421 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZEDWYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 18:24:07 -0400
Date: Mon, 4 May 2009 23:24:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v4 1/2] eventfd: export eventfd interfaces for
	module use
Message-ID: <20090504222404.GJ8633@ZenIV.linux.org.uk>
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175745.26758.94086.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504175745.26758.94086.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 01:57:45PM -0400, Gregory Haskins wrote:
> @@ -56,6 +57,7 @@ int eventfd_signal(struct file *file, int n)
>  
>  	return n;
>  }
> +EXPORT_SYMBOL_GPL(eventfd_signal);

perhaps, but...

> @@ -197,6 +199,7 @@ struct file *eventfd_fget(int fd)
>  
>  	return file;
>  }
> +EXPORT_SYMBOL_GPL(eventfd_fget);

this one looks very odd.  Could you show legitimate users?

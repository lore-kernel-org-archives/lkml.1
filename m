Return-Path: <linux-kernel-owner+w=401wt.eu-S1759372AbZKFPbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372AbZKFPbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 10:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758449AbZKFPbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 10:31:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376AbZKFPbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 10:31:52 -0500
Subject: Re: [PATCH 02/10] fanotify: fscking all notification system
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linus-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       agruen@suse.de
In-Reply-To: <20091031184728.17244.73984.stgit@paris.rdu.redhat.com>
References: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
	 <20091031184728.17244.73984.stgit@paris.rdu.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Nov 2009 10:31:45 -0500
Message-Id: <1257521505.3289.10.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-31 at 14:47 -0400, Eric Paris wrote:
> fanotify is a novel file notification system which bases notification on
> giving userspace both an event type (open, close, read, write) and an open
> file descriptor to the object in question.  This should address a number of
> races and problems with other notification systems like inotify and dnotify
> and should allow the future implementation of blocking or access controlled
> notification.  These are useful for on access scanners or hierachical storage
> management schemes.

I'm not hearing the negative feedback of the past and most everyone's
questions and concerns have been addressed.  Everyone ok if I drop these
into -next?

-Eric


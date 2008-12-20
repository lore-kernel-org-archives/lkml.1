Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbYLTKk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbYLTKk7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 05:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbYLTKku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 05:40:50 -0500
Received: from kandzendo.ru ([195.178.208.66]:36174 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbYLTKkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 05:40:49 -0500
Date: Sat, 20 Dec 2008 13:40:48 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Niraj kumar <niraj17@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [Question] inotify : process based filtering of events
Message-ID: <20081220104048.GB23632@ioremap.net>
References: <b82a89170812192251u3544f087x94775b6864f5ae8d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b82a89170812192251u3544f087x94775b6864f5ae8d@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, Dec 20, 2008 at 12:21:33PM +0530, Niraj kumar (niraj17@gmail.com) wrote:
> I am trying to use inotify to monitor filesystem events but
> my problem is that I am only interested in changes that
> is being done by a particular process and it's children
> (could be the same process which used inotify APIs).
> 
> Is it possible to achieve this process based filtering of events
> using inotify infrastructure?

You can try using inotify nested attributes patch [1] and filter events
in userspace based on reported pid/tid. With the fsnotify changes coming
it may be possible to have similar functionality there.

1. Inotify nested attributes.
http://lkml.org/lkml/2008/11/25/272

2. Example usage and test application.
http://www.ioremap.net/node/73

-- 
	Evgeniy Polyakov

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbYEQMQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbYEQMQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 08:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYEQMQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 08:16:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:42755 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbYEQMQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 08:16:14 -0400
Date: Sat, 17 May 2008 14:15:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Morten Welinder <mwelinder@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Deleting large files
Message-ID: <20080517121544.GA3926@ucw.cz>
References: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-05-07 15:49:30, Morten Welinder wrote:
> Hi there,
> 
> deleting large files, say on the order of 4.6GB, takes approximately forever.
> Why is that?  Well, it is because a lot of things need to take place to free
> the formerly used space, but my real question is "why does the unlink caller
> have to wait for it?"
> 
> I.e., could unlink do the directory changes and then hand off the rest of the
> task to a kernel thread?

Yep, but implementation is not going to be trivial. Send a patch ;-).

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

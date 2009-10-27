Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbZJ0VQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbZJ0VQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 17:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932312AbZJ0VQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 17:16:20 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40861 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391AbZJ0VQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 17:16:18 -0400
Date: Tue, 27 Oct 2009 17:13:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: david@lang.hm
Cc: Greg KH <gregkh@suse.de>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] strip: move driver to staging
Message-ID: <20091027211329.GH15566@tuxdriver.com>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com> <20091023161006.GA1580@ucw.cz> <20091026165518.GE2792@tuxdriver.com> <alpine.DEB.2.00.0910261013430.11504@asgard.lang.hm> <20091026184734.GA21591@suse.de> <alpine.DEB.2.00.0910262106050.14994@asgard.lang.hm> <20091027140812.GC17208@suse.de> <alpine.DEB.2.00.0910271136530.11504@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910271136530.11504@asgard.lang.hm>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 11:39:54AM -0700, david@lang.hm wrote:

> while I definantly agree that this driver is unlikly to have many users,  
> unless it is known broken (which David Miller has stated that it is, but  
> had not been mentioned previously in this thread), how can you know that  
> the number of users has dropped below 1?

You are free to disagree, but IMHO these devices are so unlikely to
still be in use that the burden of proof of whether or not the driver
works lies upon a forthcoming user.  Further, such a user needs to
be at least willing to test patches and probably needs to be in a
position to analyze most "normal" problems that might materialize.
IOW, such a user needs to be a de facto maintainer.

Blindly holding onto a driver not which not only has no known users
but which is believed to have no users at all merely because we can't
_prove_ it is broken is just a waste of resources.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

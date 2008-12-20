Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYLTRN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYLTRN5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 12:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYLTRNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 12:13:46 -0500
Received: from tservice.net.ru ([195.178.208.66]:55873 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbYLTRNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 12:13:46 -0500
Date: Sat, 20 Dec 2008 20:13:40 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Niraj kumar <niraj17@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [Question] inotify : process based filtering of events
Message-ID: <20081220171340.GA4655@ioremap.net>
References: <b82a89170812192251u3544f087x94775b6864f5ae8d@mail.gmail.com> <20081220104048.GB23632@ioremap.net> <b82a89170812200513q1a27b62ap590fb6fbad930a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b82a89170812200513q1a27b62ap590fb6fbad930a@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 06:43:01PM +0530, Niraj kumar (niraj17@gmail.com) wrote:
> I was hoping to add a flag (similar to IN_ATTRS that you have added)
> which, when used, will only collect events for the calling
> process and it's children...

With nested attributes patch you can add your own callback which will
check private list of interested pids and only add event into the queue
when current credentials match stored data. IMHO that will br much
smaller amount of work than extending inotify with new flag and redoing
new event structure processing. But it is up to you to decide of course
:)

-- 
	Evgeniy Polyakov

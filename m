Return-Path: <linux-kernel-owner+w=401wt.eu-S934750AbXEHIlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934750AbXEHIlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934665AbXEHIlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:41:20 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:52001 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934670AbXEHIlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:41:19 -0400
Date: Tue, 8 May 2007 10:38:27 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Albert Cahalan <acahalan@gmail.com>
cc: arvidjaar@mail.ru, hirofumi@mail.parknet.co.jp,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: Long file names in VFAT broken with iocharset=utf8
In-Reply-To: <787b0d920705072143q63e56f23j18c6b0dbfb270883@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705081036000.17280@yvahk01.tjqt.qr>
References: <787b0d920705072143q63e56f23j18c6b0dbfb270883@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 8 2007 00:43, Albert Cahalan wrote:
>
> I have an idea to deal with this, but first a rant...
>
> At two bytes per character, you get 127 characters in a filename.
> That's wider than the standard 80-column display, and far wider
> than the 28 or 29 characters that an "ls -l" has room for. In a
> GUI file manager or file dialog box, you'll have to scroll sideways.
> In a web browser directory listing, you'll almost certainly have
> to scroll sideways. Must of this even applies to Windows tools.
>
> In other words, this is user error. Somebody thought that a filename
> was a place to store a document, probably a README file. What next,
> shall we MIME-encode an icon into the filename?

Surprise surprise, Microsoft Word uses the document's title as filename.
So when you write your diploma thesis about "The Recent Improvements on
The Completely Fair Scheduler And The Staircase Deadline Scheduler and
its Impact On The Community and Mailing Lists", Word is likely to use
that as a filename. Maybe truncated a bit, I have not figured out the
heuristic yet.

> Fix: the vfat driver should use the 8.3 name for such files.

Or the 31-character ISO Level 1(?).

Jan
-- 

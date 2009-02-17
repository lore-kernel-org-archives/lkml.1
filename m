Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbZBQUHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbZBQUHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 15:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZBQUHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 15:07:05 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:45636 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbZBQUHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:07:04 -0500
Date: Tue, 17 Feb 2009 21:08:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Junio C Hamano <gitster@pobox.com>, Ingo Molnar <mingo@elte.hu>,
       =?utf-8?B?IlMuw4dhxJ9sYXIgT251ciI=?= <caglar@pardus.org.tr>
Subject: Re: [PATCH] Add *.rej to .gitignore
Message-ID: <20090217200853.GA28693@uranus.ravnborg.org>
References: <499B1729.5040802@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499B1729.5040802@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 11:59:37AM -0800, Jeremy Fitzhardinge wrote:
> *.rej files really are unwanted.  If there are any .rej files, they can be 
> found by
> some other means (perhaps git itself could warn when committing with *.rej 
> files present,
> or add some distinct notion of "ignored files" vs "never commit" files).
> 
> (This effectively reverts 1f5d3a6b6532e25a5cdf1f311956b2b03d343a48)

When working with patch having .rej files to show up in "git status"
and "git commit" is a nice reminder to you that there was
some manual work to be done.

So unless git are educated to remind you by other means we should
keep the current behaviour and be reminded when we see .rej
files present in "git status" / "git commit".

In other words - I do not agree on applying this patch.

	Sam

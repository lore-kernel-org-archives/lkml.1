Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbYJLNB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbYJLNB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 09:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbYJLNBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 09:01:19 -0400
Received: from lazybastard.de ([212.112.238.170]:51234 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbYJLNBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 09:01:19 -0400
Date: Sun, 12 Oct 2008 15:01:04 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Pavel Machek <pavel@suse.cz>
Cc: Chris Snook <csnook@redhat.com>, Stefan Monnier <monnier@iro.umontreal.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: Filesystem for block devices using flash storage?
Message-ID: <20081012130103.GA14119@logfs.org>
References: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org> <48ED1D62.8080100@redhat.com> <20081011143552.GA1556@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081011143552.GA1556@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 October 2008 16:35:52 +0200, Pavel Machek wrote:
> 
> I don't think ext3 is safe w.r.t. whole eraseblocks disappearing. So
> if you write data 'nearby' root directory and power fails, bye bye
> filesystem, and journal will not help.

No device I've ever seen is that stupid.

Judging the reports I have of actual corruptions, the main problem
appears to be write disturb.  Writes tend to inject charge into
neighboring blocks.  If any part of the device gets hammered with
writes, there is a good chance of corruption nearby.

Write performance is another issue, of course.

Jörn

-- 
You ain't got no problem, Jules. I'm on the motherfucker. Go back in
there, chill them niggers out and wait for the Wolf, who should be
coming directly.
-- Marsellus Wallace

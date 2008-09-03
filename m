Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbYICUWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbYICUWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 16:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbYICUWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 16:22:13 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:48731 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754161AbYICUWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:22:12 -0400
Date: Wed, 3 Sep 2008 16:22:12 -0400
To: Roland Dreier <rdreier@cisco.com>
Cc: Mike Isely <isely@pobox.com>, Hans Verkuil <hverkuil@xs4all.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: CodingStyle question: multiple statements on a single line
Message-ID: <20080903202211.GG12476@csclub.uwaterloo.ca>
References: <200809030021.00122.hverkuil@xs4all.nl> <ada7i9ufa7x.fsf@cisco.com> <Pine.LNX.4.64.0809021830400.17907@cnc.isely.net> <adaskshvzw6.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaskshvzw6.fsf@cisco.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 11:38:01AM -0700, Roland Dreier wrote:
> 	if (a) {
> 		b;
> 	}
> 
> to
> 
> 	if (a)
> 		b;
> 

Why oh why the kernel do this stupid style?

I hate that.  It makes debuging such a pain in the @#$@#$.  Anytime you
want to do anything in that area you have to add back the missing '{}'
around the statement, so that you can add debug statements to the
condition.

Stupid stupid stupid!!!

It is so annoying when you accidentally break the code by trying to
debug it by doing:

	if (a)
		printk("Trying to do b\n");
		b;

Usually kernel style makes sense, but this part is stupid, inconsistend
with how any condition with multiple statements is done, and error
prone, especially when trying to debug.

Who's stupid idea was this anyhow?

-- 
Len Sorensen

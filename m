Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZGXRfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZGXRfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 13:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZGXRft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 13:35:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:35970 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbZGXRfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 13:35:48 -0400
Date: Fri, 24 Jul 2009 10:34:22 -0700
From: Greg KH <gregkh@suse.de>
To: Trevor Pace <tr212206@dal.ca>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Removed useless retval variables in usb-serial.c
Message-ID: <20090724173422.GA10989@suse.de>
References: <20090724124803.ltfbg57ooyoko0gs@my5.dal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090724124803.ltfbg57ooyoko0gs@my5.dal.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 12:48:03PM -0300, Trevor Pace wrote:
> Removed useless return value variables.

Why are they "useless"?

They seem useful to me, especially as it causes the code to fall out of
the function at the bottom, and not in the middle, which makes
maintaining the code easier to do over time, right?

And did this actually cause any generated code to be
faster/smaller/better?

Oh, and you seem to have messed up a bit of whitespace, please always
run your patches through scripts/checkpatch.pl first.

thanks,

greg k-h

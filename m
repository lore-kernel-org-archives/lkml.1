Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYFAQyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYFAQyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYFAQyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:54:17 -0400
Received: from phoenix.clifford.at ([88.198.7.52]:57599 "EHLO
	phoenix.clifford.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYFAQyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:54:16 -0400
Date: Sun, 1 Jun 2008 18:34:39 +0200
From: Clifford Wolf <clifford@clifford.at>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add 'make no2modconfig' config generation target
Message-ID: <20080601163439.GI1369@clifford.at>
References: <1212217507-32126-1-git-send-email-clifford@clifford.at> <20080531083034.GA2569@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531083034.GA2569@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, May 31, 2008 at 10:30:34AM +0200, Sam Ravnborg wrote:
> On Sat, May 31, 2008 at 09:05:07AM +0200, Clifford Wolf wrote:
> > The new 'make no2modconfig' make target creates a new kernel
> > config based on the current one, switching all tristate options
> > from 'n' to 'm'.
> 
> In what situations do we need this functionality?

I'm using this patch (respectively its predecessors) since many years in
ROCK Linux to auto-generate our general purpose kernel configurations, by
copying the default kernel config, forcing some variables to yes or no and
then setting all tristate options which are on 'n' to 'm' using this patch.

the only alternative would be to manually check the kernel configurtion for
each new kernel and setting all new tristate options to 'm' by hand. what a
waste of energy that would have been for the last couple of years..  ;-)

yours,
 - clifford

-- 
For extra security, this message has been encrypted with double-ROT13.

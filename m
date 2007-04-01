Return-Path: <linux-kernel-owner+w=401wt.eu-S1751288AbXDAEjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbXDAEjm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 00:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbXDAEjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 00:39:42 -0400
Received: from vitelus.com ([63.99.9.247]:35719 "EHLO vitelus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbXDAEjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 00:39:41 -0400
Date: Sat, 31 Mar 2007 21:39:06 -0700
From: Aaron Lehmann <aaronl@vitelus.com>
To: Jim Paris <jim@jtan.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Silent corruption on AMD64
Message-ID: <20070401043905.GV15189@vitelus.com>
References: <20070401012736.GT15189@vitelus.com> <20070401030315.GA24080@jim.sh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070401030315.GA24080@jim.sh>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 08:03:16PM -0700, Jim Paris wrote:
> Since it shows up under heavy load that includes unrelated devices, I
> think ruling out hardware problems is important.  Some suggestions:

I've been able to narrow it down to the Realtek Ethernet card. I can't
reproduce the problem using onboard Ethernet, whereas the Realtek card
causes trouble in any slot. However, I still don't know whether it's a
hardware or software issue, or whether it's caused directly or
indirectly by the Realtek card.

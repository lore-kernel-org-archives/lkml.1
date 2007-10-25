Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbXJYTqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbXJYTqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXJYTqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:46:43 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:48753 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbXJYTqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:46:42 -0400
Date: Fri, 26 Oct 2007 04:46:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: linuxsh <linuxsh-dev@lists.sourceforge.net>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [SUPERH / PATA / SCSI] Unable to do start userland after kernel boot
Message-ID: <20071025194618.GA26344@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Kristoffer Ericson <kristoffer.ericson@gmail.com>,
	linuxsh <linuxsh-dev@lists.sourceforge.net>,
	linux-main <linux-kernel@vger.kernel.org>
References: <20071025212240.a50c18b6.Kristoffer.ericson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025212240.a50c18b6.Kristoffer.ericson@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 09:22:40PM -0700, Kristoffer Ericson wrote:
> The bottom line seems to be that it fails to attach scsi sg0. It
> explains why it doesn't work, but not why it stopped working. And this
> has nothing to do with the current kernel config, I've been over that
> the last 4 days. It all started when I synced my jlime-current.git
> repository with linux-2.6.git. As you can see I had 2.6.23-rc6 and then
> synced up to 2.6.23-rc8/rc9 and thats when the troubles started.
> 
At least that suggests it's not fallout from the INTC changes in -rc1, so
that helps to narrow it down a bit. Since you have a known good and bad,
it would be nice if you could bisect this to figure out what exactly
caused the regression. There weren't any SH-specific changes between rc6
and rc8/rc9 at least.

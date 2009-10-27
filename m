Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbZJ0OVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbZJ0OVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbZJ0OVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:21:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbZJ0OVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:21:20 -0400
Date: Tue, 27 Oct 2009 07:05:58 -0700
From: Greg KH <gregkh@suse.de>
To: Eric Miao <eric.miao@canonical.com>
Cc: Bryan Wu <bryan.wu@canonical.com>, kernel-team@lists.ubuntu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Android logger: fix compiling error
Message-ID: <20091027140558.GA17208@suse.de>
References: <1256316741-14053-1-git-send-email-bryan.wu@canonical.com>
 <f17812d70910262140i63e4d2f0x708521a9287ca386@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f17812d70910262140i63e4d2f0x708521a9287ca386@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 12:40:07PM +0800, Eric Miao wrote:
> > Compiling broke since commit a99bbaf5ee6bad1aca0c88ea65ec6e5373e86184
> >    headers: remove sched.h from poll.h
> >
> > Adding <linux/sched.h> to fix this compiling bug.

I have now just marked the android drivers as broken, as this is not the
only build error in them at the moment :(

thanks,

greg k-h

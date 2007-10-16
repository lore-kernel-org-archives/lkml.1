Return-Path: <linux-kernel-owner+w=401wt.eu-S935104AbXJPS2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935104AbXJPS2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbXJPS2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:28:02 -0400
Received: from 1wt.eu ([62.212.114.60]:3148 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbXJPS2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:28:01 -0400
Date: Tue, 16 Oct 2007 20:24:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Vitaliy Ivanov <vitalivanov@gmail.com>, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
Message-ID: <20071016182401.GE23326@1wt.eu>
References: <1192383445.8372.18.camel@dell1.softservecom.com> <20071014182542.GA2832@1wt.eu> <35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com> <20071014223921.GA4677@1wt.eu> <1192542889.29039.66.camel@dell1.softservecom.com> <20071016154138.GA23326@1wt.eu> <20071016105603.5cd42ff6.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016105603.5cd42ff6.zaitcev@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 10:56:03AM -0700, Pete Zaitcev wrote:
> On Tue, 16 Oct 2007 17:41:38 +0200, Willy Tarreau <w@1wt.eu> wrote:
> 
> > OK, I have no objection, but please apply the fixes the le16 problem as
> > suggested by Pete and Greg first. Also, you will probably receive more
> > comments, and/or criticisms from further reviews. This is normal and
> > expected. You just have to fix your code so that it can be merged.
> 
> I do not object to the driver (with byte order fixed), although it seems
> written oddly... E.g. lots of trivial comments, the open count locked
> by wrong lock. But I do not want to hold the 2.4 version hostage to
> errors of the mainline. We should've caught them when we merged adutux
> into Greg's tree. I have to admit I'm skipping reviewing a lot of 2.6.

I really appreciate your position, Pete. It's fair and motivating for
newcomers. I hope Vitalyi will be able to forward-port some fixes and
cleanups to 2.6 in the future.

Thanks,
Willy


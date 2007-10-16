Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbXJPS2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbXJPS2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935077AbXJPS2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:28:14 -0400
Received: from mail.softservecom.com ([195.160.232.17]:43087 "EHLO
	mail.softservecom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935050AbXJPS2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:28:12 -0400
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Reply-To: vitalivanov@gmail.com
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Willy Tarreau <w@1wt.eu>, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       vitalivanov@gmail.com
In-Reply-To: <20071016105603.5cd42ff6.zaitcev@redhat.com>
References: <1192383445.8372.18.camel@dell1.softservecom.com>
	 <20071014182542.GA2832@1wt.eu>
	 <35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com>
	 <20071014223921.GA4677@1wt.eu>
	 <1192542889.29039.66.camel@dell1.softservecom.com>
	 <20071016154138.GA23326@1wt.eu>
	 <20071016105603.5cd42ff6.zaitcev@redhat.com>
Content-Type: text/plain
Message-Id: <1192558947.29039.135.camel@dell1.softservecom.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.5 (1.4.5-1) 
Date: Tue, 16 Oct 2007 21:22:27 +0300
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2007 18:22:27.0478 (UTC) FILETIME=[81A02360:01C81021]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-16 at 20:56, Pete Zaitcev wrote:
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

No Pete. Seems it's my changes. Actually such approach is proposed by
usb-skeleton in 2.4. Will rework code to lock it correctly and clean
code from trivial comments.

Will back to this soon.

Vitaliy


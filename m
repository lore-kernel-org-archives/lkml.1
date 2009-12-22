Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbZLVQ6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbZLVQ6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 11:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbZLVQ6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 11:58:31 -0500
Received: from cantor.suse.de ([195.135.220.2]:45767 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZLVQ6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 11:58:30 -0500
Date: Tue, 22 Dec 2009 08:56:21 -0800
From: Greg KH <gregkh@suse.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/27] Driver core: devtmpfs: prevent concurrent
 subdirectory creation and removal
Message-ID: <20091222165621.GB2334@suse.de>
References: <20091211212642.GA6624@kroah.com>
 <1260570289-6997-4-git-send-email-gregkh@suse.de>
 <cc557aab0912210537pdc076e7p5c90303fb6a32b66@mail.gmail.com>
 <ac3eb2510912210637n629ec609vf838a8b572867ffa@mail.gmail.com>
 <cc557aab0912220610w7c3c57aaq3b6d96f6eb7085ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc557aab0912220610w7c3c57aaq3b6d96f6eb7085ca@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 04:10:31PM +0200, Kirill A. Shutemov wrote:
> On Mon, Dec 21, 2009 at 4:37 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > On Mon, Dec 21, 2009 at 14:37, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> >> v2.6.33-rc1-96-gdd59f6c:
> >> I guess it can be related to this commit.
> >
> > The fix is already pending here:
> >  http://patchwork.kernel.org/patch/68337/
> 
> One more problem: you don't unlock dirlock if kstrdup() failed.

Care to provide a patch?

thanks,

greg k-h

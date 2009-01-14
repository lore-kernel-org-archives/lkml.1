Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZANDyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZANDyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 22:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZANDyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 22:54:11 -0500
Received: from kroah.org ([198.145.64.141]:44998 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753262AbZANDyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 22:54:10 -0500
Date: Tue, 13 Jan 2009 19:52:37 -0800
From: Greg KH <greg@kroah.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Robert Love <rlove@google.com>, linux-kernel@vger.kernel.org
Subject: Re: lowmemory android driver not needed?
Message-ID: <20090114035237.GB16442@kroah.com>
References: <20090114010223.GA21380@kroah.com> <20090114021801.GA14759@bulgaria.corp.google.com> <d6200be20901131830r7103ff8eoe0314f9faf89d89b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20901131830r7103ff8eoe0314f9faf89d89b@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 06:30:39PM -0800, Arve Hjønnevåg wrote:
> The oom killer does not kick in until all caches are emptied. Our user
> space code changes the oom_adj value of processes that are no longer
> in the foreground so that they killed first (the process saves its
> state but does not exit). To avoid excessive demand paging, the low
> memory killer will kill these processes when the memory available
> drops below a threshold.

That makes sense.  Can you provide a bit of documentation that I can
include in the driver so that people can actually use the thing?  :)

Alan, does this sound like it should remain in the tree?

thanks,

greg k-h

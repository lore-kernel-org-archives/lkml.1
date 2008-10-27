Return-Path: <linux-kernel-owner+w=401wt.eu-S1751669AbYJ0KHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbYJ0KHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYJ0KGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:06:54 -0400
Received: from nn7.de ([85.214.94.156]:35282 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbYJ0KGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:06:53 -0400
Subject: Re: [2.6.28-rc1 regression] appletouch
From: Soeren Sonnenburg <kernel@nn7.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0810260244450.22126@twin.jikos.cz>
References: <1224966797.5303.3.camel@localhost> <49038C5C.7000708@gmail.com>
	 <Pine.LNX.4.64.0810260244450.22126@twin.jikos.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Oct 2008 11:06:50 +0100
Message-Id: <1225102010.5063.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-26 at 02:45 +0200, Jiri Kosina wrote:
> On Sat, 25 Oct 2008, Jiri Slaby wrote:
> 
> > > I've noticed that the mouse does no longer work in X using 2.6.28-rc1 
> > > nor does the fn-key emulation work on my macbookpro 1,1.
> > > It perfectly works with 2.6.27.3...
> > Please follow
> > http://bugzilla.kernel.org/show_bug.cgi?id=11825
> 
> Yup. The patch fixing this issue is in the bunch for which the pull 
> request has already been sent to Linus, but it didn't happen yet.

indeed w/ -rc2 the mouse works fine. Re' fn-keys the path in /sys
changed to /sys/module/hid_apple/parameters/fnmode ...

Soeren

Return-Path: <linux-kernel-owner+w=401wt.eu-S932540AbYEFUqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540AbYEFUqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757892AbYEFUqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:46:40 -0400
Received: from styx.suse.cz ([82.119.242.94]:38082 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755241AbYEFUqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:46:39 -0400
Date: Tue, 6 May 2008 22:46:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dag Bakke <dag@bakke.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Diego 'Flameeyes' Petteno" <flameeyes@gmail.com>
Subject: Re: [PATCH] fix apple alu keyboard with numpad
In-Reply-To: <20080506125406.dc047710.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805062244130.11363@jikos.suse.cz>
References: <4814612F.5030606@bakke.com> <20080506125406.dc047710.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Andrew Morton wrote:

> > The nice apple alu keyboards with numpads are pretty much unusable in
> > vanilla 2.6.25.
> > (http://images.apple.com/keyboard/images/gallery/wired_1_20070813.jpg)
> > Hitting the 'clear' key (=numlock) disables the numpad, and maps multiple
> > alphanumeric keys to numpad symbols in typical laptopkeyboard fashion.
> This conflicts rather directly with 
> hid-disable-numlock-emulation-for-apple-aluminium-keyboards.patch below 
> (hm, seems we didn't get a changelog for that one).

Hi,

I have just today applied Diego's patch into my tree [1], he has provided 
the changelog out of list to me.

> Jiri, what should we do here?

Dag, I think Diego's patch should solve the issue you are seeing, right?

[1] http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commit;h=ffe6f7b799e33f51732520979f9c253a252b9d5e

Thanks,

-- 
Jiri Kosina

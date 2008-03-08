Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYCHLNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYCHLNn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 06:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYCHLNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 06:13:34 -0500
Received: from twin.jikos.cz ([213.151.79.26]:45547 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbYCHLNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 06:13:33 -0500
Date: Sat, 8 Mar 2008 12:13:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, devzero@web.de, pavel@ucw.cz,
       linux-kernel@vger.kernel.org, rick@vanrein.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
In-Reply-To: <47D26A00.7050308@zytor.com>
Message-ID: <Pine.LNX.4.64.0803081210540.18589@twin.jikos.cz>
References: <182234194@web.de> <20080304132724.GB32383@elte.hu>
 <47D26A00.7050308@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Mar 2008, H. Peter Anvin wrote:

> > as i said it in another reply to this thread, it would be perfectly 
> > acceptable for upstream to merge an easier to use boot option - be 
> > that badmem=addr$size or excludemem=addr$size. Please send a patch :-)
> It already called:
> 	memmap=addr$size
> ... and has been implemented for years.  Does the badram patch do anything
> different?  (And yes, I agree the $/@/# is ugly.)

I admit that I haven't examined badram too closely, but I think that what 
it has in addition to what you can get by simple 'memmap=..' is that it 
allows you to use bitmasks to mask particular address patterns.

-- 
Jiri Kosina
SUSE Labs


Return-Path: <linux-kernel-owner+w=401wt.eu-S1161769AbXDXNf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161769AbXDXNf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 09:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161770AbXDXNf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 09:35:58 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:43088 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161769AbXDXNf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 09:35:57 -0400
Date: Tue, 24 Apr 2007 15:30:53 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Neil Brown <neilb@suse.de>, Theodore Tso <tytso@mit.edu>,
       Eric Hopper <hopper@omnifarious.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
In-Reply-To: <462D4D6E.50809@zytor.com>
Message-ID: <Pine.LNX.4.61.0704241530360.2490@yvahk01.tjqt.qr>
References: <462C2E5B.1080008@redhat.com> <Pine.LNX.4.64.0704230353000.25153@server.thyself>
 <462C4858.3050006@redhat.com> <Pine.LNX.4.64.0704230555020.25153@server.thyself>
 <462C4D32.4000909@redhat.com> <Pine.LNX.4.64.0704230611430.25153@server.thyself>
 <462C5034.9090403@redhat.com> <Pine.LNX.4.64.0704230640540.25153@server.thyself>
 <20070423010445.454eda63.akpm@linux-foundation.org> <20070423135216.GA2744@omnifarious.org>
 <20070423225640.GA1663@thunk.org> <462D46DF.4090802@zytor.com>
 <17965.19438.292138.959036@notabene.brown> <462D4D6E.50809@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 23 2007 17:21, H. Peter Anvin wrote:
> Neil Brown wrote:
>> 
>> Our you could think outside the circle:
>> Store all your "small files" as symlinks, then use "symlink" to create
>> them and "readlink" to read them. (You would probably end up use
>> symlinkat and readlinkat).
>> Only one system call instead of three.
>> I guess you don't get meaningful permission bits then... I wonder if
>> that really matters.
>
> For some applications, oh yes it does.

Put them in a protected directory.


Jan
-- 

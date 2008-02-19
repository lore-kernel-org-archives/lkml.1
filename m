Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbYBSTj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbYBSTj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYBSTjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:39:49 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:41646 "EHLO
	QMTA02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093AbYBSTjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:39:48 -0500
X-Authority-Analysis: v=1.0 c=1 a=rITDv7nW5hcA:10 a=RTvpSqOKSDzHYzQ0LfkA:9
 a=aLNKA45qXKF-cariz6d3mYnzk7YA:4 a=MxZ3bB5I4kYA:10
To: linux-kernel@vger.kernel.org
From: Karl Dahlke <eklhad@comcast.net>
Reply-to: Karl Dahlke <eklhad@comcast.net>
Subject: Where to put adapters, /proc is cool
Date: Tue, 19 Feb 2008 14:39:45 -0500
Message-ID: <20080119143945.eklhad@comcast.net>
Mime-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So without knowing what an adapter is in this context /proc
> seems to be a bad choice.

The best explanation might be an example.
I use my Jupiter speecha dapter all day, every day.
It basically sends text to a speech synthesizer.
It also has some virtual files.
/proc/adapters/jupiter/synth can be used by a process
to send text directly to the synthesizer.

echo hello world >/proc/adapters/jupiter/synth

And I hear hello world.
I don't use this virtual file often, but sometimes it's nice.
A background process on another vt can wake me up when it's done.
And this is just one example.
Other virtual files load firmware and dictionaries into the dectalk synth, and so on.
Other people use virtual files in their adapters as well.
Really, /proc is the only place for these virtual files that interact
directly with the kernel and/or its modules;
I just wanted a fixed place under /proc for adapters to live,
like sys ttys scsi net, and so on.

>/proc is for processes (and was in the past used for all sort of crap).

I gather from this that you don't like the way people
are using /proc for user/kernel communication.
I suppose it's a matter of taste,
but I think it is one of the very coolest things about linux, period.
I don't have to create 27 new ioctl calls, and have them approved by everyone,
and make sure they don't collide with 363 other ioctl calls, every time I want
some new communication with the kernel or its drivers.
I can read and write files under /proc.
I'm sorry, but I think it's cool.

Cool or not, it seems to be here to stay,
and I humbly suggest a standard location for adapters and their virtual files.
/proc/adapters

Karl Dahlke

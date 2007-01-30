Return-Path: <linux-kernel-owner+w=401wt.eu-S1751053AbXA3VNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053AbXA3VNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbXA3VNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:13:41 -0500
Received: from [139.30.44.16] ([139.30.44.16]:3534 "EHLO
	gockel.physik3.uni-rostock.de" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751053AbXA3VNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:13:41 -0500
Date: Tue, 30 Jan 2007 22:13:39 +0100 (CET)
From: Tim Schmielau <tim@physik3.uni-rostock.de>
To: Tom Burns <tom.i.burns@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Bug: 2.6.15 Process accounting fails to account for small time
 slice loads (still)
In-Reply-To: <671c20540701301056l6ff1d876xb8df0d9d83ea2c8a@mail.gmail.com>
Message-ID: <Pine.LNX.4.63.0701302156050.15094@gockel.physik3.uni-rostock.de>
References: <671c20540701300824p54dad7dbw43fe916bc8c98d45@mail.gmail.com> 
 <Pine.LNX.4.63.0701301840470.14441@gockel.physik3.uni-rostock.de>
 <671c20540701301056l6ff1d876xb8df0d9d83ea2c8a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007, Tom Burns wrote:

> That would be great if you could find that patch - I can worry about
> porting it to the current kernel.  We're having an issue where our
> device, while routing large amounts of network traffic, reports 0% CPU
> utilisation when it cannot be the case, and I think this is the cause.

Here is one patch for CPU cycle accounting: (although I'm not sure that's 
really the one I had in mind)

  http://lkml.org/lkml/2004/6/23/78

It might also be worth having a look at oprofile:

  http://oprofile.sourceforge.net/

If you are on IA64 or PPC rather than i386, ppacc might help you:

  http://lkml.org/lkml/2006/1/13/308
  http://ppacc.sourceforge.net/about.html

Although I'd guess you are not on PPC or S390 as these already to correct 
CPU cycle accounting (IIRC).

Hope that helps,
Tim

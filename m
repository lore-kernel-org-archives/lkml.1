Return-Path: <linux-kernel-owner+w=401wt.eu-S933446AbXGWABR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446AbXGWABR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765919AbXGWABA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:01:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:42028 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761423AbXGWAA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:00:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KL7tuxQQF8Q0bkheamH9koIXHGMI9ODl9PRsys+QUDVGHxdoxPO4i2gykt6z+c/U9g4G1FjH1Ohq08r7e7IxWoeqMxY5OBjF4fAb1VNoQUev/DqcaIe935EwyZij4Gtd8peCvzB3qmu8QjfNKe3f2OL2Yu5nVbwqNyf7JKeqS3c=
Message-ID: <9e4733910707221700o16659129ra2daed0833f02cf0@mail.gmail.com>
Date: Sun, 22 Jul 2007 20:00:58 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Git Mailing List" <git@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Git tree for old kernels from before the current tree
In-Reply-To: <20070722211314.GA13850@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910707221349s462aa11bj714956f7cdc72aac@mail.gmail.com>
	 <Pine.LNX.4.64.0707222257540.32367@fbirervta.pbzchgretzou.qr>
	 <20070722211314.GA13850@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/22/07, Paul Mundt <lethal@linux-sh.org> wrote:
> Anyone still sending 2.4 patches with the intent of them being moved
> forward and applied to a current kernel needs to be killfiled.

These patches are coming from companies that aren't interested in
participating in the GPL process but are being forced into releasing
code because of the license. Some of them will go out of their way to
make the changes difficult to read. All of the patches I am looking at
come from embedded systems, many of these systems are still shipping
2.4 kernels.

Most of the patches contain junk, but there are occasional diamonds.
One I'm looking at contains code for accessing encryption hardware.
The goal is to look at the vendor diffs and see if I can spot anything
useful. Spotting something useful can be hard if there are 100,000
lines of noise in the diffs, I'm also trying to spot missing drivers
so that we can ask for more code.

-- 
Jon Smirl
jonsmirl@gmail.com

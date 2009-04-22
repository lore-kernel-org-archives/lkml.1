Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZDVPME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZDVPME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZDVPLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:11:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58915 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751841AbZDVPLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:11:52 -0400
Date: Wed, 22 Apr 2009 16:12:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Igor Zhbanov <izh1979@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Idea: Feature information / extensions dispatcher syscall.
Message-ID: <20090422161257.2743ea33@lxorguk.ukuu.org.uk>
In-Reply-To: <f44001920904220746k356550abk6783b8cae003685d@mail.gmail.com>
References: <f44001920904220712ye1644c9y90d637bf4ac3bbe@mail.gmail.com>
	<871vrkpyae.fsf@basil.nowhere.org>
	<f44001920904220732h2d6d18cfwef53af31bb218b87@mail.gmail.com>
	<f44001920904220746k356550abk6783b8cae003685d@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But in some cases syscalls are more convenient than reading/writing/ioctling
> in /proc, /sys or /dev.

A syscall and an ioctl are the same thing except that you need a file
handle for one of them.

> And I suggest to regulate syscalls usage and reserve a set of numbers
> "home" modules used in some organizations only.

We have file system naming so you can open device or sysfs and the like
files to do that job. That avoids the problem of trying to keep numbering
sane.

Alan

--
	"Alan, I'm getting a bit worried about you."
				-- Linus Torvalds

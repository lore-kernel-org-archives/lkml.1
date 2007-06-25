Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbXFYGPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbXFYGPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 02:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbXFYGPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 02:15:00 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:32786 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644AbXFYGO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 02:14:59 -0400
In-Reply-To: <20070624203837.GE21478@ftp.linux.org.uk>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org> <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <2bd4710c5c9abe1b1e423f11425c1ea5@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Date: Mon, 25 Jun 2007 08:13:57 +0200
To: Al Viro <viro@ftp.linux.org.uk>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Humm...  Right, so __builtin_offsetof() needs special treatment too.
> Oh, bugger.  Is
> 	offsetof(struct foo, a.x[n])
> a documented extension?

It is.  See  info gcc -> C Extensions -> Offsetof


Segher


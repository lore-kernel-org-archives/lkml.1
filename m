Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbXFYGRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbXFYGRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 02:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbXFYGRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 02:17:00 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:48410 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752152AbXFYGQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 02:16:59 -0400
In-Reply-To: <20070624214253.GL7590@daikokuya.co.uk>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org> <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <20070624214253.GL7590@daikokuya.co.uk>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <decc78d5943353c7bc07ee7e4566e836@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-sparse@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Date: Mon, 25 Jun 2007 08:16:33 +0200
To: Neil Booth <neil@daikokuya.co.uk>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> don't forget -> if you're going to accept extra stuff.  GCC forgot ->
> with the parser rewrite, yes I filed a PR.

-> is not allowed within the second arg to __builtin_offsetof().
Or do you mean something else?  What's the PR #, and did it ever
get fixed?


Segher


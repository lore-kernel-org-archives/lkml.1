Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbYBGFqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbYBGFqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 00:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYBGFpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 00:45:53 -0500
Received: from 1wt.eu ([62.212.114.60]:1754 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbYBGFpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 00:45:52 -0500
Date: Thu, 7 Feb 2008 05:57:16 +0100
From: Willy Tarreau <w@1wt.eu>
To: dann frazier <dannf@hp.com>
Cc: Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.4: USB: fix DoS in pwc USB video driver
Message-ID: <20080207045716.GB17032@1wt.eu>
References: <20080207020618.GB14829@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207020618.GB14829@ldl.fc.hp.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 07:06:18PM -0700, dann frazier wrote:
> This is a 2.4 backport of a linux-2.6 change by Oliver Neukum.
> (commit 85237f202d46d55c1bffe0c5b1aa3ddc0f1dce4d)

That's weird, because I remember about this one I checked while working
on 2.6.20-stable. For an unknown reason, I thought that it did not affect
2.4 version of the driver, and I was apparently wrong :-/

> CVE-2007-5093 was assigned for this issue.
> This backport has been compile-tested only.

I've applied it, and I have such a webcam lying somewhere, so I'll be able
to test.

Thanks Dann!
Willy


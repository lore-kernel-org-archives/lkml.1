Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbXJDTJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbXJDTJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 15:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760932AbXJDTIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 15:08:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33504 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760739AbXJDTIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 15:08:51 -0400
Date: Thu, 4 Oct 2007 21:10:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch 00/34] s390 patches for 2.6.24
Message-ID: <20071004191015.GA23211@uranus.ravnborg.org>
References: <20071004112706.574737175@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004112706.574737175@de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin.
On Thu, Oct 04, 2007 at 01:27:06PM +0200, Martin Schwidefsky wrote:
> The current set of s390 patches ready to be pushed once 2.6.23
> has hit the streets.

I noticed that I had not yet beautified the vmlinux.lds file of s390.
Please consider the next two patches for 2.6.24.

The first patch refactor vmlinux.lds to a consistent (and more readable)
style that is being gradually introduced for all archs.
Rationale behind a consistent style is to make across-all-archs
changes less error prone and to better recongnize similar patterns.
The patch moves a few labels so they get the correct value even if
ld decide to align the section a few bytes.

The second patch introduce use of PAGE_SIZE as replacemnt of the
hardcoded value 4096 and convert a few decimal numbers to hex.

	Sam

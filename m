Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbYE1Xn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbYE1Xn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 19:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYE1Xnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 19:43:50 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:34053 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbYE1Xnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 19:43:50 -0400
Date: Thu, 29 May 2008 01:44:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Doug Reiland <dreiland@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: KBUILD_DEFCONFIG change
Message-ID: <20080528234430.GA8607@uranus.ravnborg.org>
References: <6844644e0805281505g7dc813b9x5ee544e5fe957f6b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6844644e0805281505g7dc813b9x5ee544e5fe957f6b@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 06:05:28PM -0400, Doug Reiland wrote:
> The following used to work:
> ARCH=ia64 KBUILD_DEFCONFIG=bigsur_defconfig make defconfig
> 
> Now 2.6.25 makes you do:
> 
> ARCH=ia64 make KBUILD_DEFCONFIG=bigsur_defconfig defconfig

Use the shorter version:
ARCH=ia64 make bigsur_defconfig

There is no need to fiddle with KBUILD_DEFCONFIG.
KBUILD_DEFCONFIG is a pure internal thing that
may change without notice.

	Sam

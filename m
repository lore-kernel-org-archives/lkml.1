Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbXB1VN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbXB1VN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbXB1VN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:13:27 -0500
Received: from hansmi.home.forkbomb.ch ([213.144.146.165]:7379 "EHLO
	hansmi.home.forkbomb.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbXB1VN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:13:27 -0500
Date: Wed, 28 Feb 2007 22:13:24 +0100
From: Michael Hanselmann <linux-kernel@hansmi.ch>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Antonino Daplas <adaplas@pol.net>
Subject: Re: fix implicit declaration in nv_backlight.
Message-ID: <20070228211324.GA26983@hansmi.ch>
References: <20070228173625.GA3359@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228173625.GA3359@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 12:36:25PM -0500, Dave Jones wrote:
> +#ifdef __powerpc__

Is __powerpc__ defined when cross compiling? I'd rather use
CONFIG_PMAC_BACKLIGHT instead of it.

Greets,
Michael

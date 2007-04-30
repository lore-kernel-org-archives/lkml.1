Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbXD3TtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbXD3TtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbXD3TtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:49:18 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:57081 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbXD3TtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:49:17 -0400
Date: Mon, 30 Apr 2007 21:49:11 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: Revert "[POWERPC] <various>"
Message-ID: <20070430194911.GA1156@aepfle.de>
References: <46362B14.6090106@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46362B14.6090106@simon.arlott.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, Simon Arlott wrote:

> There are a few powerpc patches plus reverts in the recent push to 
> torvalds/linux-2.6 - shouldn't this be avoided whenever possible because it 
> could cause problems for people trying to use git bisect?

The reverts do not cause compile failures (I hope).
You may lose IDE if you happen to debug something on Pegasos.
I'm sure the real bisect breakers are elsewhere.

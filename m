Return-Path: <linux-kernel-owner+w=401wt.eu-S935046AbYEUDwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935046AbYEUDwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760656AbYEUDfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:35:31 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4496 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934513AbYEUDf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:35:29 -0400
Date: Wed, 21 May 2008 05:34:58 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Al Viro <viro@ftp.linux.org.uk>
cc: torvalds@linux-foundation.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] provide out-of-line strcat() for m68k
In-Reply-To: <E1JycsB-0000M9-36@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0805210531170.18184@localhost.localdomain>
References: <E1JycsB-0000M9-36@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 21 May 2008, Al Viro wrote:

> Whether we sidestep it in init/main.c or not, such situations
> will arise again; compiler does generate calls of strcat()
> on optimizations, so we really ought to have an out-of-line
> version...

It actually was strlen that was generated and not strcat.

bye, Roman

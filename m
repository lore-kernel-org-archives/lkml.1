Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbYEUKyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbYEUKyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 06:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758464AbYEUKx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 06:53:56 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3242 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbYEUKxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 06:53:55 -0400
Date: Wed, 21 May 2008 12:53:34 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Al Viro <viro@ftp.linux.org.uk>
cc: torvalds@linux-foundation.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] provide out-of-line strcat() for m68k
In-Reply-To: <20080521053012.GL28946@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0805211250180.19545@localhost.localdomain>
References: <E1JycsB-0000M9-36@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0805210531170.18184@localhost.localdomain>
 <20080521053012.GL28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 21 May 2008, Al Viro wrote:

> > It actually was strlen that was generated and not strcat.
> 
> Here it replaced strncat() with call of strcat() (gcc 4.0.1, FWIW).
> And yes, I can show you init/main.s with
> 	jbsr strcat	|
> in it generated on kernel in b0rken range...

Please use a more recent compiler, 4.0 created too many problems on m68k, 
which we only got under control with 4.1, so at least on m68k 4.0 is not 
really supported.

bye, Roman

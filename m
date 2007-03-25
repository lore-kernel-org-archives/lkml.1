Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbXCYWct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbXCYWct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 18:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbXCYWct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 18:32:49 -0400
Received: from smtp.osdl.org ([65.172.181.24]:33010 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbXCYWcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 18:32:48 -0400
Date: Sun, 25 Mar 2007 14:32:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: parag.warudkar@gmail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH]fdomain.c: get rid of unused stuff
Message-Id: <20070325143246.c4513a63.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703251206330.17623@paragw-desktop>
References: <Pine.LNX.4.64.0703251206330.17623@paragw-desktop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007 12:11:23 -0400 (EDT) Parag Warudkar <parag.warudkar@gmail.com> wrote:

> fdomain.c uses the below stuff only if PCMCIA is not defined.
> This causes unused variables to be defined when PCMCIA is not defined. 
> Wrap variables and functions around #ifndef PCMCIA appropriately to avoid 
> this.

Your email client performs space-stuffing and hence mangles patches.

> 4 less compiler warnings.

Please quote the warnings in the changelog when removing them.


> Compile tested on i386.
> 

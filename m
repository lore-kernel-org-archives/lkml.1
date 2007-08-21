Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbXHUUD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbXHUUD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbXHUUDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:03:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36684 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127AbXHUUDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:03:20 -0400
Date: Tue, 21 Aug 2007 13:02:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       dtor@mail.ru, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] Console keyboard events and accessibility
Message-Id: <20070821130233.58faaa8a.akpm@linux-foundation.org>
In-Reply-To: <20070821005718.GD3658@interface.famille.thibault.fr>
References: <20070821005718.GD3658@interface.famille.thibault.fr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007 02:57:18 +0200
Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> Some external modules like Speakup need to use the PC keyboard to control
> them and also need to get keyboard feedback (caps lock status, etc.)
> 
> This adds a keyboard notifier that such modules can use to get the keyboard
> events and possibly eat them, at several stages:

Adding hooks for non-merged modules is considered sinful.  Making these new
exports EXPORT_SYMBOL_GPL might ease the pain.

Is there any prospect of getting at least one of these "external modules
like Speakup" merged into mainline?


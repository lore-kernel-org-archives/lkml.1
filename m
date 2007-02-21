Return-Path: <linux-kernel-owner+w=401wt.eu-S932416AbXBULjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbXBULjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932422AbXBULjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:39:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416AbXBULjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:39:39 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070220.waF.48959600@egw.corp.redhat.com> 
References: <20070220.waF.48959600@egw.corp.redhat.com> 
To: "Chris Snook" <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, jeffpc@josefsipek.net
Subject: Re: [PATCH 0/2] use symbolic constants in generic lseek code 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 21 Feb 2007 11:38:32 +0000
Message-ID: <8458.1172057912@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook <csnook@redhat.com> wrote:

> Patch 1 fixes the case statements to use the symbolic constants in
> include/linux/fs.h, and should not be at all controversial.
>
> Patch 2 adds a SEEK_MAX and uses it to validate user arguments.  This makes
> the code a little cleaner and also enables future extensions (such as
> SEEK_DATA and SEEK_HOLE).  If anyone has a problem with this, please speak up.

Seems reasonable.

Acked-By: David Howells <dhowells@redhat.com>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbZLCHwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbZLCHwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 02:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZLCHwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 02:52:46 -0500
Received: from ozlabs.org ([203.10.76.45]:36199 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbZLCHwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 02:52:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] modpost: fix segfault in sym_is() with prefixed arches
Date: Thu, 3 Dec 2009 18:22:43 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1259812252-22041-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1259812252-22041-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912031822.44004.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009 02:20:52 pm Mike Frysinger wrote:
> The sym_is() compares a symbol in an attempt to automatically skip symbol
> prefixes.  It does this first by searching the real symbol with the normal
> unprefixed symbol.  But then it uses the length of the original symbol to
> check the end of the substring instead of the length of the symbol it is
> looking for.

Thanks, applied.

Cheers,
Rusty.

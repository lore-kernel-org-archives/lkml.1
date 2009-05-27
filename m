Return-Path: <linux-kernel-owner+w=401wt.eu-S1759782AbZE0Ffp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759782AbZE0Ffp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbZE0Ffi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:35:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34971
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbZE0Ffh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:35:37 -0400
Date: Tue, 26 May 2009 22:35:36 -0700 (PDT)
Message-Id: <20090526.223536.12323520.davem@davemloft.net>
To: sam@ravnborg.org
Cc: tj@kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/12]: sparc64: Refactor OBP cpu scanning code using an
 iterator.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090409062924.GA14255@uranus.ravnborg.org>
References: <20090408.223738.63750701.davem@davemloft.net>
	<20090409062924.GA14255@uranus.ravnborg.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 9 Apr 2009 08:29:24 +0200

> You never pass a "void *" as argument to this iterator.
> It seems cleaner to use a long or even an int as this is closer
> to the typical usage, and one can always pass a '0' when the
> argument is not used.

I've changed this to an 'int' while respinning this patch.

Thanks!

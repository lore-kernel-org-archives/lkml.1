Return-Path: <linux-kernel-owner+w=401wt.eu-S1761927AbZD3AmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761927AbZD3AmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZD3AmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:42:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53047 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZD3AmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:42:07 -0400
Date: Thu, 30 Apr 2009 01:42:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/super.c: fix sparse warning
Message-ID: <20090430004205.GO8633@ZenIV.linux.org.uk>
References: <BD79186B4FD85F4B8E60E381CAEE1909016C1B15@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909016C1B15@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 08:14:57PM -0400, H Hartley Sweeten wrote:
> Sparse reports the following in fs/super.c:
> 
>   warning: Using plain integer as NULL pointer
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Subrata Modak <subrata@linux.vnet.ibm.com>

Applied.

However, I would *really* ask you to avoid that kind of subjects in
the future.  Proper subject for that one is "NULL noise in <file>" (or
<file>:<function>.  Sparse doesn't even need to be mentioned.

sparse generates many kinds of warnings.  And they are neither equal
nor equally interesting.

Kindly use subjects that would tell what's going on; "$TOOL gives
some warning in $FILE" is bloody useless.

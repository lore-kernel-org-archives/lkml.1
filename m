Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZEILgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZEILgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 07:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZEILgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 07:36:09 -0400
Received: from smtp4.netcologne.de ([194.8.194.137]:43877 "EHLO
	smtp4.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbZEILgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 07:36:08 -0400
Date: Sat, 9 May 2009 13:36:06 +0200
From: Max Kellermann <max@duempel.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jens.axboe@oracle.com, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] make splice more generic
Message-ID: <20090509113606.GA15607@squirrel.roonstrasse.net>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>, jens.axboe@oracle.com,
	torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090507133734.450612199@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507133734.450612199@szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009/05/07 15:37, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Just after cleaning up my patches after a vacation I found Max
> Kellermann's patch on LKML implementing the first part.  I'll still
> post mine, because it's slightly simpler (no ref + unref on the buffer
> if not necessary).

I didn't do that initially, but then I wasn't sure if that is actually
valid: the get() method requires a pointer to the pipe and the buffer,
not just the underlying page.  I chose the safe path, because I don't
know that API very well.

Max

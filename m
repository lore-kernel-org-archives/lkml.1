Return-Path: <linux-kernel-owner+w=401wt.eu-S1763911AbXEWNym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763911AbXEWNym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbXEWNye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:54:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55031 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbXEWNyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:54:33 -0400
Date: Wed, 23 May 2007 14:54:32 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: "Ph. Marek" <philipp.marek@bmlv.gv.at>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] file as directory
Message-ID: <20070523135432.GX4095@ftp.linux.org.uk>
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <E1HqoGh-0001kd-00@dorka.pomaz.szeredi.hu> <20070523113925.GT4095@ftp.linux.org.uk> <200705231523.55306.philipp.marek@bmlv.gv.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705231523.55306.philipp.marek@bmlv.gv.at>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 03:23:54PM +0200, Ph. Marek wrote:
> How about some special node in eg. /proc (or a new filesystem)?
> Eg.
>    /fileAsDir/etc/passwd/owner ...
> would work for all *files*. For directories we do not know whether we're still 
> climbing the hierarchy or would like to see meta-data.

So we need to make *anything* done anywhere in the namespace to modify
the dentry tree on that fs.  Could you spell "fuck, NO"?

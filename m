Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab0BOQXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 11:23:47 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:46014 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab0BOQXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:23:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xQ8tmLuXrhXb2M1+kIVPgXyIr21fjlc1vGTodxsVVXKCPe2sTfOqlKEHlDBqnIVZg7
         UvOGNir6drPpuPrUPBzzsZWTAS7K1wRMdDW0MPwm820l82iZcT/La8D0hHaER/Owcl3R
         SwGO1/7y+EC/s8kv6t0P7FRjrCRWnyaRhFzBk=
Date: Mon, 15 Feb 2010 18:23:38 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Add flags to __d_path for suppressing suffix and
 mapping /proc/self
Message-ID: <20100215162338.GB4905@x200>
References: <201002152311.IGC00525.SFOVtLJQFMOHFO@I-love.SAKURA.ne.jp>
 <20100215161523.GA31908@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215161523.GA31908@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 11:15:23AM -0500, Christoph Hellwig wrote:
> On Mon, Feb 15, 2010 at 11:11:37PM +0900, Tetsuo Handa wrote:
> > This patch allows __d_path() to
> > (1) suppress " (deleted)" suffix if dentry was already deleted
> 
> This part looks fine to me.

Not to me. It should be

	__d_path(... int *deleted)

and caller decides what to do with deleted files.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762633AbXHQBUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762633AbXHQBUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 21:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbXHQBUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 21:20:43 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:17958 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbXHQBUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 21:20:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dINJgY31R6Ctf8BS3u+ZKdtCtnJE388aJ+vBzRGMLlKi+F6E/nMVCMSaCiSMlWhARt19CKqMXT6a/s30tXUyM+k+t6c8TELTs02BjGI0fmHeZhQf+rMoXbOh6df7lJo+C0DaX77JtQPOWeX03U3oE1rhV3wQxTCNRdFeBUaL+Bo=
Message-ID: <46C4F79C.6020905@gmail.com>
Date: Fri, 17 Aug 2007 10:19:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: don't warn on removal of a nonexistent binary
 file
References: <Pine.LNX.4.44L0.0708161609060.2553-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0708161609060.2553-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> This patch (as960) removes the error message and stack dump logged by
> sysfs_remove_bin_file() when someone tries to remove a nonexistent
> file.  The warning doesn't seem to be needed, since none of the other
> file-, symlink-, or directory-removal routines in sysfs complain in a
> comparable way.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun

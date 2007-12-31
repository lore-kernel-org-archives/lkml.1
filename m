Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbXLaUEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbXLaUEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 15:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbXLaUD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 15:03:56 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:26479 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbXLaUDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 15:03:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hoR1bZpMznsbZEVwcsjhJGJjjvTaOaZYWFD9d0OYjunpbzoTCvqqvpVWuF4xSh4ZuZWYWv6BurL3NhuLsIncS8EDwapijASjg6CEhL91kTBPwshZJIrg9uu0rAXB9Lj2q16rJcUOXn/I1+1LBO0dkajPuP4UpdYxQCyilWfdd2w=
Date: Mon, 31 Dec 2007 21:05:22 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       ocfs2-devel@oss.oracle.com
Subject: Re: [RFC][PATCH] byteorder: introduce le32_add_cpu & friends to
	core
Message-ID: <20071231200519.GA10232@joi>
References: <20071230190619.GA13757@joi> <20071231193801.GS13821@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071231193801.GS13821@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 11:38:01AM -0800, Mark Fasheh wrote:
> On Sun, Dec 30, 2007 at 08:06:34PM +0100, Marcin Slusarz wrote:
> > There are many places where these functions would be useful.
> > (just look at: grep -r 'cpu_to_[ble12346]*([ble12346]*_to_cpu.*[-+]' linux-src/)
> > What do you think?
> > 
> > ps: this patch depends on http://lkml.org/lkml/2007/12/25/35
> > --
> > 
> > add inline functions which add native byte order variable to
> > little/big endian variable to core header and as an example
> > convert ext3 to use them
> 
> You might want to note where you got these functions from in your message.
Yes, my mistake, sorry about that.

> Also, it would be easier to follow these changes if you had broken things up
> into two patches - one which moved stuff from ocfs2 into generic helpers and
> a 2nd one to convert ext3.
Will do (tomorrow).

> Looking into my crystal ball, I see a bunch of "convert to using byteorder
> math macros" patches coming down the pipe. Since we're talking about disk
> fields where a mistake could be costly, I suggest that any patch more than a
> couple of lines should be tested by the submitter with sparse. A statement
> that sparse didn't produce any new warnings (with the patch applied) could
> be included in the description.
Good idea. Thanks.

Marcin

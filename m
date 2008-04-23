Return-Path: <linux-kernel-owner+w=401wt.eu-S932487AbYDWGMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbYDWGMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 02:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbYDWGMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 02:12:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:10961 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbYDWGMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 02:12:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fZynR8G9XFyYu0eN0YWTaGyefB/0KyTnR3OQsLVZh5tXNOE7pQIZD6xLirVXn7byu6yhN6z6bGwKQkVtlfJkHo/MJSLs8oCBRQgXglOj14CJwUivhZAb332dSrI9xLmiHYxXPLMFstCbcqXHoofyD+pPUk92c6lsT91h20mYCzg=
Message-ID: <e2e108260804222312u673df0bbic3e30089f1d4a238@mail.gmail.com>
Date: Wed, 23 Apr 2008 08:12:41 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: Unexport of blk_get_queue and blk_put_queue
Cc: "Philipp Reisner" <philipp.reisner@linbit.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Lars Ellenberg" <lars.ellenberg@linbit.com>
In-Reply-To: <20080421122413.GD6011@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e2e108260804180443s429e0db7j3a48056088634ed9@mail.gmail.com>
	 <20080421122413.GD6011@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 2:24 PM, Adrian Bunk <bunk@kernel.org> wrote:
> On Fri, Apr 18, 2008 at 01:43:17PM +0200, Bart Van Assche wrote:
>  > I noticed that blk_get_queue and blk_put_queue were unexported in the
>  > 2.6.25 kernel. Are you aware that this breaks DRBD (an out-of-tree
>  > kernel module) ?
>
>  no, I verify that my patches don't break Linus' tree and often also peek
>  at -mm, but not at external modules.
>
>  And I'm a proponent of "no stable kernel API, but as many external
>  modules as reasonably possible should be part of the kernel", so emails
>  like yours are always a good point to start asking why the code isn't in
>  Linus' tree.
>
>  What happened to DRBD?
>  It didn't seem that far from getting merged half a year ago.

You mean this message: http://lkml.org/lkml/2007/7/21/255 ?
(Added Lars Ellenberg in CC.)

Bart.

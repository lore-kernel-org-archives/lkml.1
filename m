Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbYDBKUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbYDBKUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 06:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbYDBKUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 06:20:42 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:43286 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbYDBKUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:20:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mUjLtqCLfuCDSxHRZyZbubfZgrkqVYiQ4nTWNiHo0DFY1ufhL2ortBpNpP8e4PmvDl05ZZIg0V8ITmR3H6IMDpwO0A2kJzbwwcY8RGgacf0CVl8uOPHaITHjW/BgF5euf4Y5QHzfJzBtx4gJH03+gA+ezYA/DsU6bFisV0Ef6KI=
Message-ID: <47F35DF5.5010201@gmail.com>
Date: Wed, 02 Apr 2008 12:20:37 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Drop an empty byteorder/generic.h from being exported
 to userspace.
References: <alpine.LFD.1.00.0804012134300.10852@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.00.0804012134300.10852@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2008 03:38 AM, Robert P. J. Day wrote:
> Since the entire meaningful contents of generic.h is wrapped by the
> __KERNEL__ test, drop it from being passed to userspace, and remove
> the now superfluous __KERNEL__ test.
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
>   is there some value in allowing an effectively empty header file to
> be exported to userspace?

Not breaking the userspace? The file is included in non-__KERNEL__ sections from 
byteorder/*_endian.h.

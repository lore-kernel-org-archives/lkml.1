Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbYJQPgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbYJQPgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbYJQPge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:36:34 -0400
Received: from gw.goop.org ([64.81.55.164]:45751 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbYJQPgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:36:33 -0400
Message-ID: <48F8B0FF.3010005@goop.org>
Date: Fri, 17 Oct 2008 08:36:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Chris Lalancette <clalance@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH]: Fix Xen domU boot with batched				 mprotect
References: <48F5CE10.3060403@redhat.com> <48F6274D.76E4.0078.0@novell.com> <48F61919.2050005@goop.org> <48F72C7A.76E4.0078.0@novell.com> <48F76773.2090700@goop.org> <48F85711.76E4.0078.0@novell.com> <48F8ACF7.6050905@goop.org> <48F8CBC4.76E4.0078.0@novell.com>
In-Reply-To: <48F8CBC4.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Is e.g. 256Mb tiny? KERNEL_IMAGE_SIZE these days is 512Mb... Indeed,
> when it was 40Mb (up until a few releases ago), this indeed wouldn't
> matter.
>   

Well, the real point is that anyone doing a test on such high kernel 
addresses is almost certainly buggy anyway.  I guess a more precise 
statement is that it returns well-defined results for any va the calling 
code could reasonably be using, not for any random bit pattern.

But I think we're getting into the weeds here.

    J

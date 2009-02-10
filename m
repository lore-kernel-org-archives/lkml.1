Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbZBJBvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbZBJBvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 20:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZBJBvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 20:51:23 -0500
Received: from gw.goop.org ([64.81.55.164]:34335 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbZBJBvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 20:51:22 -0500
Message-ID: <4990DD97.5090705@goop.org>
Date: Mon, 09 Feb 2009 17:51:19 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH 10/11] x86: make lazy %gs optional on x86_32
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <1234186798-16820-11-git-send-email-tj@kernel.org> <49907203.4010009@goop.org> <4990D817.7010906@kernel.org>
In-Reply-To: <4990D817.7010906@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hmmm... I was (lazily) trying to add that %gs can only be cleared if
> it's being managed lazily because otherwise it might be being used by
> the kernel for other purposes.  :-)
>
> Is my understanding correct?

Oh, hm, I see.  We only want to zero it if we're using lazy gs, 
otherwise it contains something useful...  I need to run now, but I'll 
look at it again in a few hours.

    J

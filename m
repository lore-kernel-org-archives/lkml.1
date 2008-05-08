Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYEHXyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYEHXyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYEHXx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:53:59 -0400
Received: from gw.goop.org ([64.81.55.164]:42902 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbYEHXx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:53:58 -0400
Message-ID: <4823928D.7080907@goop.org>
Date: Fri, 09 May 2008 00:53:49 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] call_usermodehelper_setup() should use GFP_KERNEL
References: <20080508193224.0EFF.KOSAKI.MOTOHIRO@jp.fujitsu.com> <4822F8E4.4040401@goop.org> <20080509084248.43B5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080509084248.43B5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> UMH_WAIT_EXEC and UMH_WAIT_PROC mean wait on finish of exec or process exit.
> I can't imagine situation that exec is waitable *and* allocate isn't waitable.
>   

Yeah, that's why I was asking about UMH_NO_WAIT, where the caller may 
not want to wait, but the context would allow the allocation to block if 
necessary.

    J

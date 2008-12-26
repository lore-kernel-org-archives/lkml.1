Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbYLZNzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbYLZNzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 08:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYLZNyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 08:54:50 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:20555 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbYLZNys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 08:54:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=E8H4/WsUIOw+fA2LqPnZyC1RnNlGfCv48X2t5WMO9p4Vi3EdRnSgBNIzFjdEfyxPaW
         t5vsmR1tLcQ/CsRJix7LF7mSWovkg8LihTzW9W1S/g5Ep6uVDw6Gop5hZa3l9t5f0C4B
         Jfu+VWRJwSpUafWM0QROel8aX/0QjDFahnDA0=
Message-ID: <2f11576a0812260554x7096102ct8a39d0316f5afd6f@mail.gmail.com>
Date: Fri, 26 Dec 2008 22:54:47 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@gmail.com>
To: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH] Check return from argv_split() in do_coredump().
Cc: xiyou.wangcong@gmail.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <200812262220.FAE48915.OSLtOFJFVHOFQM@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812240616.mBO6GGEe078727@www262.sakura.ne.jp>
	 <20081226144548.GB3156@hack.private>
	 <200812260700.mBQ70uH3009595@www262.sakura.ne.jp>
	 <20081226150653.GD3156@hack.private>
	 <200812262220.FAE48915.OSLtOFJFVHOFQM@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --------------------
> Subject: Check return from argv_split() in do_coredump().
>
> do_coredump() accesses helper_argv[0] without checking helper_argv != NULL.
> Though, likely helper_argv != NULL.
>
> Below versions have this problem.
>
>  2.6.24.7
>  2.6.25.20
>  2.6.26.8
>  2.6.27.10
>  2.6.28
>  mmotm 2008-12-24-01-20

please remove target version from patch description (it is not useful
for git log).
and please cc to linux-stable.

otherthings, looks good to me.
   Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

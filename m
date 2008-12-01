Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYLAXfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYLAXfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 18:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYLAXf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 18:35:28 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:47009 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbYLAXf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 18:35:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rN3PIaE+DVhqBrqssDCz+nLxEEPAbJYMwK0XKZta3WXRjINbgj71TzUNMtRkR1VjDX
         Mi2LJVsDe4XAzc1dMwq5PxpW8qS9DjCUdKsylCWd3xzI6cgxrxLKPcMrfE0SQemR22Ul
         nJVsoDZXXr9mFKoL7MjHDJCJWDUXJeQbN2Iek=
Message-ID: <2375c9f90812011535p667aa233u86271f07c852444@mail.gmail.com>
Date: Mon, 1 Dec 2008 23:35:26 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: balbir@linux.vnet.ibm.com, "Am?rico Wang" <xiyou.wangcong@gmail.com>,
       jdike@addtoit.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH][UML] Boot broken due to buffer overrun
In-Reply-To: <20081130030128.GA8948@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081129100830.GA24128@balbir.in.ibm.com>
	 <2375c9f90811290503s1b4cb9aelaecccc680c6e37d0@mail.gmail.com>
	 <20081130030128.GA8948@balbir.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 3:01 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> I did not fix that with UNIX_PATH_MAX since, mconsole_user.c already includes
> sys/un.h and sys/socket.h and I did not want to include kernel headers
> linux/socket.h and linux/un.h there. I could have hard-coded those
> values to 108, but I just let it be for now. If you feel strongly
> about it, it can be done.
>

No, you can leave it to me. :)

Thanks.

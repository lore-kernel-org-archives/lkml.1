Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbXKMK6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbXKMK6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbXKMK6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:58:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:3620 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbXKMK6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:58:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FpEGFLiXvissooGzWD1dj8Jbo8JRrW+1YUj8DnRCmSYobbs6RZskfvfkQLV2fxLNcaf8GyZL5j1T94KcwNmop8lRWnRkg+qVxzjkgYOlQbc5t80yiEPnOObKTEFjVIpeedudoGeeV2P8LMYflMAagsqGjWZqtOBgzKdF57NlAKg=
Message-ID: <b6fcc0a0711130258l4f003cfaje258d10efe94b89b@mail.gmail.com>
Date: Tue, 13 Nov 2007 13:58:00 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Tilman Schmidt" <tilman@imap.cc>
Subject: Re: [2.6.24-rc2] make C=1 killed by sparse 0.4 choking on kernel/sched.c
Cc: linux-kernel@vger.kernel.org, "Sam Ravnborg" <sam@ravnborg.org>,
       josh@freedesktop.org
In-Reply-To: <47398255.3030309@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47398255.3030309@imap.cc>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/07, Tilman Schmidt <tilman@imap.cc> wrote:
> When trying to build 2.6.24-rc2 with checking by sparse 0.4,
> my "make" run dies with:
>
>   CHECK   kernel/sched.c
> sparse: flow.c:805: rewrite_parent_branch: Assertion `changed' failed.

http://git.kernel.org/?p=devel/sparse/sparse.git;a=commitdiff;h=8d79ef8142b754061d6ef26a3ba29ba503a3621d

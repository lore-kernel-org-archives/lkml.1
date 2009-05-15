Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbZEOUmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbZEOUmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 16:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZEOUmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 16:42:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:57904 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbZEOUmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 16:42:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=F23tkTtJLb52ue86SowX8FNt6bdl+ov7nYPUNyqoVXy8Vt0lvk709iW++WPJ2pGvAE
         6qdNs0c4Zcb/WjchW4XK4nC00RhiijStsy6+UGmsOAJ8hDyiGPey7ulaVeWmqt1e/gh/
         wimg08Yf58xUNSzn7hRzV1xRa8kDG1XTmXbto=
MIME-Version: 1.0
In-Reply-To: <56e1b5710905150628w912759an21c82efc3fae7f4a@mail.gmail.com>
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
	 <84144f020905150323m76cdd775p87abec356e355d37@mail.gmail.com>
	 <56e1b5710905150628w912759an21c82efc3fae7f4a@mail.gmail.com>
Date: Fri, 15 May 2009 23:42:08 +0300
X-Google-Sender-Auth: bd36f14b4bc98248
Message-ID: <84144f020905151342w3565e8bcq4c6e7397e6c802b@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Floris Kraak <randakar@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 4:28 PM, Floris Kraak <randakar@gmail.com> wrote:
> Quite honestly I still believe just disabling this check is the best
> thing to do.

Agreed. The proposed "fixes" to silence the warning don't improve the
code and apparently in some cases they even increase kernel text.

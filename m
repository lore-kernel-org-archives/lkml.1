Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbZLTVx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbZLTVx6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 16:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbZLTVx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 16:53:57 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:59415 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbZLTVx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 16:53:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D1gqaLc7KC/aXIaa6HcDK8MpBR9lY03mi0++z5IJtKkANUVGWrVXEGp2exlxVn1vuj
         00jIvx1nni36wSnOS5wjd6DHVsrgn9YdhAZ6sbMUFVlX3kMxwecwKzZTHb7L11DgTgeF
         rR/9H1CGTVOWKiA5Qj9wyJI435NYM9gGCjPew=
MIME-Version: 1.0
In-Reply-To: <20091220212515.GP18217@ZenIV.linux.org.uk>
References: <1261344092-30700-1-git-send-email-a.beregalov@gmail.com>
	 <20091220212515.GP18217@ZenIV.linux.org.uk>
Date: Mon, 21 Dec 2009 00:53:54 +0300
Message-ID: <a4423d670912201353r53ed19cegc5061c3510e6ecf@mail.gmail.com>
Subject: Re: [PATCH] fs/compat_ioctl.c: fix build error when !BLOCK
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/21 Al Viro <viro@zeniv.linux.org.uk>:
> On Mon, Dec 21, 2009 at 12:21:32AM +0300, Alexander Beregalov wrote:
>> Fix this build error when CONFIG_BLOCK is not set.
>> fs/compat_ioctl.c:1604: error: 'SG_SET_TRANSFORM' undeclared
>
> Do you want that through VFS tree?  I'm going to send a bunch of assorted
> fixes tomorrow morning, so I can pass that one at the same time...

Yes, please.

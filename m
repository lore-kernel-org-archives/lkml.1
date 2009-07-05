Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbZGETgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbZGETgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 15:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZGETgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 15:36:14 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:45421 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbZGETgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 15:36:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JzynYnZzGX3Mi/EJmXMyBK2l0bkV1EbBDBt+s62G3LA+9zqpArN6sbX+Vfhy2C8Drq
         LNRRM9qX0HSYpK5KfKhFrrm+E5Iu5ejT+vCn80XvlY/foH2aO7QPTAiW8bYPpeJjG9GS
         17A0kpz/kyIA/N1wINuwaSBD4gNHSOUPb/6CM=
MIME-Version: 1.0
In-Reply-To: <E1MLruc-0007O1-Sp@pomaz-ex.szeredi.hu>
References: <E1MLa4R-00054S-94@pomaz-ex.szeredi.hu> <2547.1246393535@redhat.com> 
	<E1MLruc-0007O1-Sp@pomaz-ex.szeredi.hu>
From: Ulrich Drepper <drepper@gmail.com>
Date: Sun, 5 Jul 2009 12:35:51 -0700
Message-ID: <a36005b50907051235h17f559c6w1937998c7eec0b0@mail.gmail.com>
Subject: Re: [RFC PATCH] vfs: new open(2) flag to open filesystem node
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 21:59, Miklos Szeredi<miklos@szeredi.hu> wrote:
> This patch adds a new open flag, O_NODE.  This flag means: open just
> the filesystem node instead of the object referenced by the node.

I am still not sure whether this shouldn't rather be an implementation
of POSIX's O_SEARCH or whether it is already an O_SEARCH
implementation. If it's close enough it seems wasteful to add yet
another mode.  I probably cannot research it this coming week but can
try to look at it the week after that.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbZJSJO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbZJSJO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 05:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbZJSJO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 05:14:57 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:42619 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZJSJO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 05:14:56 -0400
X-Greylist: delayed 1566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2009 05:14:56 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RWZqZmTJJ+g7fqwj1tj/8QODW2lY/2fNEni9dCuoUpOv9DZ6jULUQKcUKlphSbjy0B
         BndWtLSmB7BONB6xBY/Vbu/fovbR3RaPs8ePKD7GQ9PGLJy3k+cAGNPZ4lbVOl0m2C4I
         7jyraJAda5zkvm/QllYPs3eccPwSwcafZwln8=
MIME-Version: 1.0
In-Reply-To: <20091019082556.GV20961@kernel.dk>
References: <4ADC1BAE.9060508@gmail.com> <20091019082556.GV20961@kernel.dk>
Date: Mon, 19 Oct 2009 16:48:55 +0800
Message-ID: <412e6f7f0910190148m79d7910et358d0b3627e39aa2@mail.gmail.com>
Subject: Re: PATCH: sendfile() checks f_op.sendpage() instead of 
	f_op.splice_write() wrongly
From: Changli Gao <xiaosuo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 4:25 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, Oct 19 2009, Changli Gao wrote:
>
> Question is, if the check should just be dropped completely, since we
> use fallback default handlers if the fs doesn't have
> ->splice_read/->splice_write().

Agree with you. I think we can drop it.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)

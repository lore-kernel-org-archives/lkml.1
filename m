Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0CIO7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 09:59:08 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:33562 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab0CIO7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 09:59:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=tjJVyyOnHm9IuEZFjB9VqnBEg9lSefdodTQPU7AsFcTy/RhtVy32p39uAR8ilEFyMe
         OtXboHVqP2P3OX4sjnJyulyNF6aNwVxY1DYT7+1ykTFa4T2K4LofJlA6FdcRHgcVCo7P
         QlvbbBuPy665yjWSqNpzN7rNpNHPMmeg8yME4=
MIME-Version: 1.0
In-Reply-To: <21d7e9971003090046n7da34978n36b1745184f412a@mail.gmail.com>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org> 
	<20100308094647.GA14268@elte.hu> <20100308173008.7ae389ab@lxorguk.ukuu.org.uk> 
	<alpine.LFD.2.00.1003080948060.3989@localhost.localdomain> 
	<20100308190857.400bde09@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1003081115280.3989@localhost.localdomain> 
	<20100308192744.5f40a5ee@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1003081132370.3989@localhost.localdomain> 
	<20100309072938.GA6137@elte.hu> <21d7e9971003090046n7da34978n36b1745184f412a@mail.gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Tue, 9 Mar 2010 06:58:44 -0800
Message-ID: <a36005b51003090658y4b57ad19u3c0fddc2f6d3745f@mail.gmail.com>
Subject: Re: Upstream first policy
To: Dave Airlie <airlied@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 00:46, Dave Airlie <airlied@gmail.com> wrote:
> selinux relabels are the new fsck.
>
> maybe we need selinux3 or chunk-selinux.

Once the fanotify stuff is in (or however it'll be called) the new
relabel process could temporarily install itself to intercept all
filesystem operations and fix up files on demand while going along
it's normal operation in the background.  No reason to stall the
system completely.

If this is the biggest complaint then you should be supportive of the approach.

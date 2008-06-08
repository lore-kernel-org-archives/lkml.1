Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbYFHOiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbYFHOiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 10:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbYFHOiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 10:38:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:29580 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbYFHOiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 10:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vacckb3mtdB2oGLdb8snIF+vWGOPqsrW1DHgAFg5jmFmIqfLMQS7SvnA2zR15OksAp
         BwEb+/Yd8GUQInOp5y6HNuc+yQugIurZARGboBPoM8qhaZ20atlNmfnzG3vbFje1y0JX
         5P0mEDAeu8Uom5egq4Km38yeChw8dNrJOZmds=
Date: Sun, 8 Jun 2008 22:34:34 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Thorsten Knabe <linux@thorsten-knabe.de>
Cc: Jeff Dike <jdike@addtoit.com>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [BUG] Linux 2.6.25.4 task_struct leak
Message-ID: <20080608143434.GF2487@hacking>
References: <483EC624.90503@thorsten-knabe.de> <20080601213134.GJ4018@sequoia.sous-sol.org> <20080602010546.GA8578@c2.user-mode-linux.org> <484719C7.2020502@thorsten-knabe.de> <20080605004925.GA15461@c2.user-mode-linux.org> <484BC4DF.5000605@thorsten-knabe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484BC4DF.5000605@thorsten-knabe.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 01:39:11PM +0200, Thorsten Knabe wrote:
>
>Hello Jeff.
>
>Your assumption about ptrace causing the task_struct leak seems to be
>right. I bisected the problem down to a few commits using the repository
>at git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git.
>
>Commit b7b71725fb9584454bfe5f231223bd63421798fb is the last known commit
>that does not leak task_structs, whereas commit
>a97f52e67890fda6b373c1c1895ff1c1c69b36c8 is leaking task_structs.
>Revisions in between do not even compile.
>Also I had to apply the changes from commit
>f9cb02b0be4de3c51edfdd701754e13d9a2d20d6 to most of the kernels I have
>tested, otherwise the UML process would crash on startup.

Add Cc to Roland McGrath <roland@redhat.com>.


-- 
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.

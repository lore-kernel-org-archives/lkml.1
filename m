Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbXJVGRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbXJVGRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 02:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbXJVGQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 02:16:59 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:51505 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbXJVGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 02:16:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=LfQvjxfWLU5z5Qyhuqer2kNRBq42y7863Z2kcP0ngSqtYPhuUWRHhENn+wyRbQfK+lw0Jqvl0eCOeZbNcQqB3pbfoMayLJF9a80TB6xr/nCNw00UIYGb8TJBz2pIM3SfIJHDnpv51Sh1oxN4+EGQ4Gf+6jOaM9Ta6rlpd4TJbtQ=
Date: Mon, 22 Oct 2007 14:12:46 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Jeff Dike <jdike@addtoit.com>,
       Nix <nix@esperi.org.uk>, Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in
	2.6.23-final.
Message-ID: <20071022061245.GG2998@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <200710111754.46854.rob@landley.net> <200710200252.37919.p.giarrusso@gmail.com> <87y7dyhv2u.fsf@hades.wkstn.nix> <20071021114854.GF2455@hacking> <20071021130848.GA4621@c2.user-mode-linux.org> <20071021132031.GI2455@hacking> <20071021154346.GW8181@ftp.linux.org.uk> <20071022043746.GF2998@hacking> <20071022052214.GY8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022052214.GY8181@ftp.linux.org.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 06:22:14AM +0100, Al Viro wrote:
>On Mon, Oct 22, 2007 at 12:37:46PM +0800, WANG Cong wrote:
>> >Fallout continues; I've got a preliminary patch for it.  Basically, we
>> >need to stop doing -U__i386__ et.al.
>> >
>> 
>> Hi, Al.
>> 
>> I applied your patch and recompiled the kernel. But it failed again.
>> ;(
>
>Details would be welcome...  Notes: SMP on UML is no more; UML_NET_VDE
>depends on having some userland library installed.  Aside of those two
>it ought to build.
>
>Build log on failing build would be nice, along with .config.

I build UML for non-SMP x86. But I don't know about UML_NET_VDE. ;(

Errors threw out by gcc (too many) are put here:
	http://wangcong.org/down/errors.txt

And my .config is located here:
	http://wangcong.org/down/dot_config

(Errors look like same as without your patch.)

-- 
May the Source Be With You.

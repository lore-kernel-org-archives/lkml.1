Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbXJVG4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbXJVG4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 02:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbXJVG4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 02:56:03 -0400
Received: from ag-out-0708.google.com ([72.14.246.242]:43259 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbXJVG4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 02:56:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=k7txXGiKUS0QKSA+3RTT5LwgBudRvGahd5LaEVfB07pspN0ZL2Ycb3PfLt4v138KOkX2HIuqLRngXo3UsjBUcZiPzZeHTCNJpAqIF1jumRh+6JX0M2TsZniJsDS4D1a3tIftvaWSs8Pg15TXTV2OS/VH5+Fe8NpWB9MnjJDKdCs=
Date: Mon, 22 Oct 2007 14:52:02 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Nix <nix@esperi.org.uk>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       Jeff Dike <jdike@addtoit.com>, Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in
	2.6.23-final.
Message-ID: <20071022065202.GI2998@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <200710200252.37919.p.giarrusso@gmail.com> <87y7dyhv2u.fsf@hades.wkstn.nix> <20071021114854.GF2455@hacking> <20071021130848.GA4621@c2.user-mode-linux.org> <20071021132031.GI2455@hacking> <20071021154346.GW8181@ftp.linux.org.uk> <20071022043746.GF2998@hacking> <20071022052214.GY8181@ftp.linux.org.uk> <20071022061245.GG2998@hacking> <87d4v7fy5i.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d4v7fy5i.fsf@hades.wkstn.nix>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 07:42:33AM +0100, Nix wrote:
>On 22 Oct 2007, WANG Cong uttered the following:
>> I build UML for non-SMP x86. But I don't know about UML_NET_VDE. ;(
>>
>> Errors threw out by gcc (too many) are put here:
>> 	http://wangcong.org/down/errors.txt
>
>It's hard to tell without LOCALE=C, but those are the sorts of results
>I'd expect if you had run make {old,menu,x}config without specifying
>ARCH=um, so you've configured for one architecture and are now trying
>to build another.
>
>Where is the include/asm symlink pointing to in your build tree?

$ ls -l include/asm
lrwxrwxrwx 1 wangcong wangcong 6 2007-10-22 12:34 include/asm -> asm-um

OK. Let me do the following:

	$ make mrproper
	...
	$ make defconfig ARCH=um
	...
	#
	# configuration written to .config
	#
	$ make ARCH=um
	(Still tons of errors here...)

Am I wrong or I missed something?

Regards.

-- 
May the Source Be With You.

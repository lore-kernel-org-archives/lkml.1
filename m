Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbXJVEls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbXJVEls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 00:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbXJVEll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 00:41:41 -0400
Received: from ag-out-0708.google.com ([72.14.246.243]:44439 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbXJVElk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 00:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=KRudjWQoKrES9hMnfmyUcKdfODdw1fX7/JC4zQt6O3RVH5qHq09swllpm/fs8/YuxcMRhz1Ox+h6QDSoMez1LLYdRYNV1KXJnIO1zPsUfIogwgG6ZEs4JSNDUIFt982rOltn3npe4b6I8Esipo8+uYdfPIdKljcpewU5fIXKXZs=
Date: Mon, 22 Oct 2007 12:37:46 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Jeff Dike <jdike@addtoit.com>,
       Nix <nix@esperi.org.uk>, Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in
	2.6.23-final.
Message-ID: <20071022043746.GF2998@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <200710111754.46854.rob@landley.net> <200710200252.37919.p.giarrusso@gmail.com> <87y7dyhv2u.fsf@hades.wkstn.nix> <20071021114854.GF2455@hacking> <20071021130848.GA4621@c2.user-mode-linux.org> <20071021132031.GI2455@hacking> <20071021154346.GW8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071021154346.GW8181@ftp.linux.org.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 04:43:46PM +0100, Al Viro wrote:
>On Sun, Oct 21, 2007 at 09:20:32PM +0800, WANG Cong wrote:
>> On Sun, Oct 21, 2007 at 09:08:48AM -0400, Jeff Dike wrote:
>> >On Sun, Oct 21, 2007 at 07:48:54PM +0800, WANG Cong wrote:
>> >> UML still doesn't build on 2.6.23-git16.
>> >> 
>> >> Gcc threw out many errors, I put them in the web:
>> >> 	http://wangcong.org/down/errors.txt
>> >
>> >Looks like either you need to run mrproper and try again, or maybe
>> >fallout from the x86 merge, with include/asm-um/arch pointing to
>> >include/asm-i386 instead of include/asm-x86.  Although I though Al had
>> >UML building in the presence of the x86 merge.
>> >
>> 
>> Hi, Jeff!
>> 
>> I have tried `make mrproper' before `make ARCH=um', but it still
>> failed. ;(
>
>Fallout continues; I've got a preliminary patch for it.  Basically, we
>need to stop doing -U__i386__ et.al.
>

Hi, Al.

I applied your patch and recompiled the kernel. But it failed again.
;(

Regards.

WANG Cong


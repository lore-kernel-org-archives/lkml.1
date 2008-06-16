Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbYFPMVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbYFPMVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYFPMUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:20:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:48774 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbYFPMUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:20:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:sender;
        b=P/Mghdl0G4/rxVFHtvRG6hCON7c3RbMMA9YBUL1y4ewmv9iZ3jUCFvbnKU+8tdcfY4
         wGo0+gE6Dx4MYTMdKQdhTz9W5WIlxh7zhXby2mglakMrgxKlOovSdrpaxWBsZxplsKU9
         E8g9ZhXZD1n5vSg9DxTEBY1ZAfij7X4Ec8d0I=
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, dhowells@redhat.com,
       andi@firstfloor.org, "Kirill A. Shutemov" <k.shutemov@gmail.com>
Subject: Re: [PATCH v2] export linux/a.out.h
References: <1213565555.26255.522.camel@pmac.infradead.org>
	<1213604973-7073-1-git-send-email-jacmet@sunsite.dk>
	<1213617663.26255.708.camel@pmac.infradead.org>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Mon, 16 Jun 2008 14:20:47 +0200
In-Reply-To: <1213617663.26255.708.camel@pmac.infradead.org> (David Woodhouse's message of "Mon\, 16 Jun 2008 13\:01\:03 +0100")
Message-ID: <87abhl7eqo.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "David" == David Woodhouse <dwmw2@infradead.org> writes:

Hi,

 David> Please see  git.infradead.org/users/dwmw2/aout-2.6.git

 David> David Woodhouse (6):
 David>       Include <asm/a.out.h> in fs/exec.c only for Alpha.
 David>       Remove last traces of a.out support from ELF loader.
 David>       Remove #ifdef CONFIG_ARCH_SUPPORTS_AOUT from <linux/a.out.h>
 David>       Export <linux/a.out.h> to userspace again.
 David>       Remove redundant CONFIG_ARCH_SUPPORTS_AOUT
 David>       Remove references to now-defunct CONFIG_ARCH_SUPPORTS_AOUT from defconfigs

 David> The first four are shown below, as a single combined patch.

Thanks David, looks good to me.

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard

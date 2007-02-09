Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbXBIVth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbXBIVth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 16:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXBIVth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 16:49:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:33416 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbXBIVth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 16:49:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SIV5BWpTncylzfnOsM4pDMwbrZo6dlQKfY2TnZaK3i8ciGix4iETFhB2RgO9nmiS2DG2yzsWLnnTx13+y2p3eV4eWJz4VUM1YczEiqeqYxwgrSXSZXpbolZUKJ/2nTZ3kb11XEfKn4cpu0GXBgLg6bzZfvBX0UG0WTGgnlwo0cg=
Message-ID: <9e0cf0bf0702091348v226ea8acra42bcf4463e9cdc9@mail.gmail.com>
Date: Fri, 9 Feb 2007 23:48:36 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/34] __initdata cleanup
Cc: linux-kernel@vger.kernel.org, bwalle@suse.de, rmk+lkml@arm.linux.org.uk
In-Reply-To: <20070209133355.d5df1ab5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702091711.34441.alon.barlev@gmail.com>
	 <20070209170005.GA8500@osiris.ibm.com>
	 <Pine.LNX.4.64.0702091831150.14457@scrub.home>
	 <20070209133355.d5df1ab5.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/9/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> If we really do have a problem here it'd be better to fix it in some
> central and global fashion: either by ensuring that each architecture's
> startup code will zero this memory or by some compiler/linker option such
> as -fno-common.

Great,
But what about the variables that are not in global scope?
As I understand from init.h description:
"Don't forget to initialize data not at file scope, i.e. within a function,
as gcc otherwise puts the data into the bss section and not into the init
section."

Best Regards,
Alon Bar-Lev.

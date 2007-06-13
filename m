Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbXFMG7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbXFMG7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 02:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbXFMG7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 02:59:10 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:48820 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754306AbXFMG7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 02:59:08 -0400
Message-Id: <466FB20D.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 13 Jun 2007 08:59:57 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Sam Ravnborg" <sam@ravnborg.org>
Cc: "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Andi Kleen" <ak@suse.de>, <linux-kernel@vger.kernel.org>,
       <patches@x86-64.org>
Subject: Re: [PATCH] x86: fix improper .init-type section references
References: <466E6BDF.76E4.0078.0@novell.com>
 <a781481a0706120414g385ccfe8j82b5b18d96d064f2@mail.gmail.com>
 <a781481a0706120509k89c331ela81f57ad0f0e29eb@mail.gmail.com>
 <466EB12B.76E4.0078.0@novell.com>
 <a781481a0706120632p54ad83d0ka0a07a9fd9b276b4@mail.gmail.com>
 <466EC08A.76E4.0078.0@novell.com>
 <a781481a0706120709v5a2d1147m9d372a8056aeba6d@mail.gmail.com>
 <20070612180002.GC15329@uranus.ravnborg.org>
 <a781481a0706122018i6273cd17y61cd95e269b5c7c9@mail.gmail.com>
 <20070613043526.GA20088@uranus.ravnborg.org>
In-Reply-To: <20070613043526.GA20088@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Sam Ravnborg <sam@ravnborg.org> 13.06.07 06:35 >>>
>> 
>> Yup, we were only discussing possibility that modpost not complain
>> about .init -> .exit references that will never go oops (because the arch
>> guarantees that).
>
>And there are no good reasosns why the rules should be different for i386
>and powerpc.
>This type of special casing is always bad.
>Think about it a little.
>Someone writes a generic driver and test it on i386 - OK.
>But for powerpc it result in a build failure. It would be so much better
>to warn about this situation early.

And I didn't mean to special case it - I meant to suggest changing the semantics
generally, which is why I gave the example of calling cleanup code (__exit)
from error paths in startup code (__init).

Jan


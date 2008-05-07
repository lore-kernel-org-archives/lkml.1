Return-Path: <linux-kernel-owner+w=401wt.eu-S1765464AbYEGV6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765464AbYEGV6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYEGV6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:58:10 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:64982 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418AbYEGV6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s49NgdNqsTMMTIYNgFVSL+St47YHXVJnxfCgj/rf5gwHazmAQhHHJmu/Racpv/V08wepokDi6vgzYsMokKuk9CMLjNWbjTyIcJOaa4W5xmQaPVTNfNbTyCgxMB9R4roW+4qvTqejTknDvWDXYOAtAHVqd52XNxQvr3HgRwni30U=
Message-ID: <dd18b0c30805071458m41c2c87cke5496febbc2cd9e6@mail.gmail.com>
Date: Wed, 7 May 2008 21:58:05 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression: starting X locks box with git master
Cc: "James Cloos" <cloos@jhcloos.com>, "Yinghai Lu" <yhlu.kernel@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200805072353.02085.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m3hcdrqb03.fsf@lugabout.jhcloos.org>
	 <86802c440804241352v2623222bt28129a2c501cff25@mail.gmail.com>
	 <m37iemq3qa.fsf@lugabout.jhcloos.org> <200805072353.02085.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 9:53 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, 25 of April 2008, James Cloos wrote:
>  > >>>>> "Yinghai" == Yinghai Lu <yhlu.kernel@gmail.com> writes:
>  >
>  > Yinghai> Do you have CONFIG_X86_PAT in your .config?
>  >
>  > I do not find that in .config at all, set or not:
>  >
>  > :; grep X86_PAT /usr/src/linux-2.6/.config
>  >
>  > returns nothing.
>  >
>  > But the kernel which dies does generate this:
>  >
>  > Apr 24 04:28:09 [kernel] [    0.000000] x86: PAT support disabled.
>
>  Has the problem been fixed in 2.6.26-rc1 or in the current -git?
>
>  Rafael
>

X86PAT was enabled in 2.6.26-rc1, the problem is when loading fglrx
there is a conflict, you have to disable X86pat for fglrx PAT to be
enabled.
regards;

-- 
Justin P. Mattock

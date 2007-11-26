Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbXKZWwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbXKZWwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbXKZWwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:52:43 -0500
Received: from rn-out-0910.google.com ([64.233.170.190]:25035 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753341AbXKZWwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:52:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Z613+1f7XHIFuM0YthmvJq2hRH4O0//iCeFKGthJJYZVcE72gIJmQsimdkI243rocaM88O+sTEgVpFw92sAhHL48xYQT8lR7eTiEDr6L1mBH+tEuPYl6aAb1MZgY0BXNZnnjXAbPjguvx9TfDiOWv04NYE6QBOGvnkx5ZaJ7MbY=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 23/27] x86: debugctlmsr kconfig
Date: Mon, 26 Nov 2007 14:52:34 -0800
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Sam Ravnborg <sam@ravnborg.org>
References: <20071125215507.4B89226F8C5@magilla.localdomain> <200711251709.01304.vda.linux@googlemail.com> <20071126075131.95A0226F8C5@magilla.localdomain>
In-Reply-To: <20071126075131.95A0226F8C5@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711261452.34825.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 November 2007 23:51, Roland McGrath wrote:
> > Why is it defined in configuration system instead of some *.h file?
>
> That seems to be existing practice for this sort of thing.
> I just followed what I saw.

I think that if such conditional constants can be defined
in header files (IOW: if they are not used elsewhere in config system,
only in the C source code), they should not be put in config system.
Don't make it more complex than it needs to be.

Sam what do you think?
--
vda

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761776AbYA1WWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761776AbYA1WWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760760AbYA1WQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:16:05 -0500
Received: from hs-out-0708.google.com ([64.233.178.248]:48646 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763279AbYA1WQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:16:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xR33hU01eP777jTzg8KHo/mnyR7OmINkIqi58i8fDatdfnB0GJbbIB7hrhUvcVjCS64avtc6lIkxcIdfW40jQGfFGYQV5T1smYX4VRFQSgF1xKyhxSL98yz47CLIcYwnvcSB52xBIiDLMQf10c4NHDocupccyedf0sYKETlsKmE=
Message-ID: <e8ca35370801281416q77158bf5qbfcaee46429e8f40@mail.gmail.com>
Date: Mon, 28 Jan 2008 23:16:00 +0100
From: "Pascal Terjan" <pterjan@gmail.com>
To: "Gerardo Exequiel Pozzi" <djgera@gmail.com>
Subject: Re: chars > 0xa0 not displayed in console since 2.6.24
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <e8ca35370801281412u3ba8f1b9k5024e0ce59f93599@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <479E5082.50208@gmail.com>
	 <e8ca35370801281412u3ba8f1b9k5024e0ce59f93599@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 28, 2008 11:12 PM, Pascal Terjan <pterjan@gmail.com> wrote:
> On Jan 28, 2008 11:00 PM, Gerardo Exequiel Pozzi <djgera@gmail.com> wrote:
> > Hello,
> Hello,
>
> > Chars are displayed OK in kernels < 2.6.24 (2.6.22.16, 2.6.23.14) with
> > the same config.
> > I booted clean with init=/bin/bash to discard distro (slackware-current)
> > problem/incompat, but the problem persist.
> >
> > This is a know problem?
>
> I think this is because the console is now by default in UTF-8 mode.

You can try with vt.default_utf8=0

> > The dmesg and config are attached.
>
> hmm no :)
>

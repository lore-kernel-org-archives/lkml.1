Return-Path: <linux-kernel-owner+w=401wt.eu-S1763410AbYA1X4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763410AbYA1X4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYA1X4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:56:03 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:31341 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYA1X4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:56:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g/Hfu/hZjn6z3+AKSYIb5AUfXY9BPOCH+6AE1sDk7LpkgD762RHoDBVX+m9C8rFHi1cRu4CSafUxH7lXfdwOu2T9jreh5/pP5BZY9H2PI463O0oGRHOHbQm6w/mMh8LUXt76V4fgkTKf7RQNGaTJejWgWc3GFF6ICgPBm16ZXGw=
Message-ID: <b6a2187b0801281555w479ae9b5pa1c3b05cffe2f9f4@mail.gmail.com>
Date: Tue, 29 Jan 2008 07:55:59 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Krzysztof Oledzki" <ole@ans.pl>
Subject: Re: cups slow on linux-2.6.24
Cc: lkml <linux-kernel@vger.kernel.org>, cups-bugs <cups-bugs@easysw.com>,
       "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>,
       "Patrick McHardy" <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       netfilter-devel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0801282348440.30640@bizon.gios.gov.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>
	 <Pine.LNX.4.64.0801282348440.30640@bizon.gios.gov.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/29 Krzysztof Oledzki <ole@ans.pl>:

> Strange. You stated that 2.6.23.12 is OK, however above patch
> was included in 2.6.23.4:
> Are you 100% sure that 2.6.23.12 is OK?

Sorry, my mistake. I had another system on 2.6.23.12 and was not OK,
so I bisected starting from 2.6.23.

git bisect good bbf25010f1a6b761914430f5fca081ec8c7accd1        # 2.6.23

So, 2.6.23.12 is not ok.

Thanks for pointing this out.

Jeff.

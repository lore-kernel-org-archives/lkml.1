Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbXIQUWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbXIQUWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757062AbXIQUWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:22:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:15214 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143AbXIQUWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:22:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uChReWdq8bGkJuVDvW9A3FXGmuMO8kZ625Ptrpmm/RgLobkITD/91e3bW1+u7KCeK6iuuUXogTBsLNEaVvXH5Jrqw5yCKN0OKqkNYGxTPUaR+cUlfNfeCrerQSoWS+4lPn371qiHXaIrNFErUrO4NIvOq4wN01QRWvVB9RuVrLo=
Message-ID: <38b2ab8a0709171322v75c5a597of9d90919f456767c@mail.gmail.com>
Date: Mon, 17 Sep 2007 22:22:17 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Ulrich Drepper" <drepper@gmail.com>
Subject: Re: x86_64: vsyscall vs vdso
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a36005b50709170735p7c98608ftf12398f7080131b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0709161324p6841c1f9h6f9422b0e6c4b5cd@mail.gmail.com>
	 <a36005b50709161346t544d3927mfbca537c869c3c58@mail.gmail.com>
	 <38b2ab8a0709170030k2b5dad5dja31edebf12ad9626@mail.gmail.com>
	 <a36005b50709170735p7c98608ftf12398f7080131b9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/07, Ulrich Drepper <drepper@gmail.com> wrote:
> On 9/17/07, Francis Moreau <francis.moro@gmail.com> wrote:
> > I think signal trampolines will still need them too. So making
> > vsyscalls configurable doesn't seem to work, does it ?
>
> vsyscalls aren't used for that.  We have a restorer in libc and could
> easily use one in the vdso.  That's what is done on x86.
>

Sorry for my ignorance but what' is 'a restorer' ?

-- 
Francis

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbXIQOf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbXIQOf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbXIQOfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 10:35:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:31519 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbXIQOfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:35:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z5ZhWLlvK/0EVTuS2AqEsz4jxl6sf4k8q8hW/Z5vk6CI/73AGWIbcn+Hs12lF7W0+hyT0f+rC7MaP4WR+uX9IDx8lj5l5ubj2Jc1e5+S+opzQ9toTi8CUbFDrVkeo7VnvloZi/pdo5JUvCQYXtsBpc7zEdK1SO2PbPLHi/cYPUM=
Message-ID: <a36005b50709170735p7c98608ftf12398f7080131b9@mail.gmail.com>
Date: Mon, 17 Sep 2007 07:35:04 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: x86_64: vsyscall vs vdso
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <38b2ab8a0709170030k2b5dad5dja31edebf12ad9626@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0709161324p6841c1f9h6f9422b0e6c4b5cd@mail.gmail.com>
	 <a36005b50709161346t544d3927mfbca537c869c3c58@mail.gmail.com>
	 <38b2ab8a0709170030k2b5dad5dja31edebf12ad9626@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/07, Francis Moreau <francis.moro@gmail.com> wrote:
> Does that mean we'll need to keep 3 different implementations of gtod
> in the kernel forever ?

That's a question for the kernel maintainers to answer.


> I think signal trampolines will still need them too. So making
> vsyscalls configurable doesn't seem to work, does it ?

vsyscalls aren't used for that.  We have a restorer in libc and could
easily use one in the vdso.  That's what is done on x86.

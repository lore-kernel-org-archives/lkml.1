Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbXIRQ61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbXIRQ61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 12:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759664AbXIRQ6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 12:58:19 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:13169 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759631AbXIRQ6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 12:58:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OmIzWbl/QODbCrQRG8Fuok+Wt/lkQYVshO/rOH9Za+yl3m+i0nP05lZ3ngDXdqw13nC3c5DIcC2z/Io7d30ap0J8uyjv3libeN+X8KaO7+ehguW7lKhyvS9SBU2rnaIbfMiYOjdqQuwYL/VNy5goBlchuKYHRsYKK3wT1QrYNL8=
Message-ID: <a36005b50709180958y33047b46oefd25aa796db2c49@mail.gmail.com>
Date: Tue, 18 Sep 2007 09:58:14 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: x86_64: vsyscall vs vdso
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <38b2ab8a0709171331s4cb302c3g5d0a4214981a2980@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0709161324p6841c1f9h6f9422b0e6c4b5cd@mail.gmail.com>
	 <a36005b50709161346t544d3927mfbca537c869c3c58@mail.gmail.com>
	 <38b2ab8a0709171331s4cb302c3g5d0a4214981a2980@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/07, Francis Moreau <francis.moro@gmail.com> wrote:
> Actually if we could easily retrieve the vdso in a process memory
> mapping (through a new syscall or /proc/self/maps), it should be easy
> for gcc/ld to statically links vdso functions into a statically linked
> app, shouldn't it ?

Nonsense.  All the code which is in the vdso has a real implementation
in libc.  No need to substitute.  The vdso is only there to adjust a
program to the actual environment in which it is executed and not in
which it is built.  Your suggestion would do the latter which is
complete and utter nonsense.

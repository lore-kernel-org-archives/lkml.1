Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbXCHF2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbXCHF2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 00:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbXCHF2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 00:28:19 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:19326 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbXCHF2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 00:28:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Gss50dzZ3f1fdwB/lBfcESKmqpwUbFFxNJg/D2VHd+0TtiMIOk/5oZu2+QL5zpgnvxCzyHlKsQFA2ZBn9gvxfP81irlS6f6fp1MGFc5XL6eS85FdvkC4Oxnm88VHzvNIVaY6M1tUFoxQPBayBb6i8ugqJw+KCYB+bvZP/iuOEKA=
Message-ID: <9c21eeae0703072128i3c63b31em3d132a6691976bf4@mail.gmail.com>
Date: Wed, 7 Mar 2007 21:28:15 -0800
From: "David Brown" <dmlb2000@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: PAGE_SIZE Availability Inconsistency
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200703080318.04631.zippel@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>
	 <20070306092917.GA5226@infradead.org>
	 <200703080318.04631.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> While I agree, NBPG is a bit of a problem, although it's only needed for aout
> coredumps AFAICT, but still needed to compile e.g. gdb.

Well then how does gdb deal with ia64? because PAGE_SIZE and friends
aren't available for that arch same with ppc.

Looking at the gdb code they do have places where they define a
PAGE_SIZE but they even mention its a bug
(gdb-6.6/libiberty/getpagesize.c:14) also grepped through their code
looking for includes of page.h come up with nothing.

- David Brown

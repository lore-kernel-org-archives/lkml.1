Return-Path: <linux-kernel-owner+w=401wt.eu-S1423100AbXBBNtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423100AbXBBNtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 08:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423089AbXBBNtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 08:49:05 -0500
Received: from hu-out-0506.google.com ([72.14.214.229]:50041 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423111AbXBBNtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 08:49:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W7QZnNRlnclTrvMKQhAp19oEhfVhkoF+tPVMfrvp/AXlwShevSA35rrG4QNyztK5iF+3uAeyCkBqAVOnoJn7gNpv7cFQxts6c+Khc2ks6cTAcGBt6FmCZGNLORiizRlpq7US2YFuvXk6Vym3J8FNhvFWNQjSqN80qsUO4L2buEs=
Message-ID: <3d8471ca0702020548n9455f4fre8c4ceea3f070a51@mail.gmail.com>
Date: Fri, 2 Feb 2007 14:48:59 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Roland Kuhn" <rkuhn@e18.physik.tu-muenchen.de>
Subject: Re: O_NONBLOCK setting "leak" outside of a process??
Cc: "Philippe Troin" <phil@fifi.org>,
       "Denis Vlasenko" <vda.linux@googlemail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <E0CFA8EB-F706-49E8-A1D1-7BAF19C8D271@e18.physik.tu-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200701272152.11087.vda.linux@googlemail.com>
	 <87bqkhuqpp.fsf@tantale.fifi.org>
	 <200702020000.40524.vda.linux@googlemail.com>
	 <87abzxbhau.fsf@tantale.fifi.org>
	 <E0CFA8EB-F706-49E8-A1D1-7BAF19C8D271@e18.physik.tu-muenchen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/2/2, Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>:

> That's a bug, right?

No, if you want something like: (echo toto; date; echo titi) > file
to work in your shell, you'll be happy to have the seek position
shared in the processes.

-- 
Guillaume

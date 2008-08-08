Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbYHHTNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbYHHTNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756589AbYHHTNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:13:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48793 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbYHHTNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:13:22 -0400
Message-ID: <489C9ACA.5060501@zytor.com>
Date: Fri, 08 Aug 2008 12:13:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: including .c files ?
References: <ac9c93b10808080425p321fac13y72a5b2b4e67ee6a9@mail.gmail.com> <489C681B.1020805@keyaccess.nl>
In-Reply-To: <489C681B.1020805@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> 
> If you think about it -- in C, #include really at least conceptually 
> means "cut & paste this in here, please" meaning headers are not 
> anything special and .h and .c seperation is a mere convention.
> 
> As we all know, conventions exist _only_ to be violated...
> 

The real issue is that the convention -- .c versus .h -- recognize *two* 
kinds of files, but there really are *three* kinds of files:

- Files meant to be included that generate no code (.h)
- Files meant to be included that generate code (???)
- Files not meant to be included (.c)

Some projects -- including the Linux kernel -- have adopted the 
convention that the middle type should be .c, others .h, others probably 
other variants.  You typically want them treated as .h files for 
purposes of generating dependencies, but like .c files for purposes of, 
say, header file include guard checking.

	-hpa

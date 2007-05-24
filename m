Return-Path: <linux-kernel-owner+w=401wt.eu-S1752090AbXEXTNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbXEXTNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 15:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbXEXTM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 15:12:57 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:61488 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbXEXTM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 15:12:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SxJNFbVI2nK1xD6t5tq8WQMdLFp4xFAbIooDiVIF8xowPG2RGETVBRf8CbvjXk6g4SoHM77sLC/yoSTQxngagL0xaGShtJutaI/Ass0YND1Cs1uBV5g/taN532VgHh4p6cl7yzykXBfSD4Wvd2vHt10DgbSM5EZEQPid93lqfEk=
Message-ID: <a781481a0705241212g787bae30md4b9e81aea465198@mail.gmail.com>
Date: Fri, 25 May 2007 00:42:44 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 3
Cc: "Richard Purdie" <richard@openedhand.com>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org
In-Reply-To: <4cefeab80705240729w6cf0f84fvb6cd86e19256b2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	 <a781481a0705231234m62327134mbfd1c1478b6fb99a@mail.gmail.com>
	 <1179995105.5880.7.camel@localhost.localdomain>
	 <a781481a0705240407p2e9933ecm8d2c9863465cdeac@mail.gmail.com>
	 <4cefeab80705240729w6cf0f84fvb6cd86e19256b2b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> On 5/24/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> > Hmm. The wrappers would clearly be inline, but if we want a common
> > low-level decompress function, we'd also need to introduce the "if (safe &&)"
> > kind of tests for those differently-defined macros which could impact
> > performance (for the _unsafe variant only, isn't it). By how much is the
> > question, and whether we really care to avoid duplicating 50 lines of code
> > to take that hit on the unsafe function (or vice versa).
>
> All this just to avoid that symlink?

Oh, yes. And also to avoid the changes to the master Makefile,
and the extra stuff in the other Makefile. And you'd even rid
yourself of some #ifdef's in the actual code. Too many upsides!

> What is so wrong with that?

We never required this kind of thing before, why now? Also note
that it requires all the extra stuff mentioned above ... why not do
away with all that too.

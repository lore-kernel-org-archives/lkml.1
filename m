Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYAQBSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYAQBSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 20:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYAQBSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 20:18:38 -0500
Received: from wx-out-0506.google.com ([66.249.82.236]:39339 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbYAQBSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 20:18:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XNaynycvwEHXdFnJxsJN+5LZ8+cuCH27YFrJDqSUQddeu2ciibQRWX6Vc9xIa13Xxf8CC+MJh1owhRvarkqvsjRyQkBAcOGGCRxAKD2xWx3wBj5AYU1SmDXxZVdSeFGGx9THu4tbsNdhWmquW8jN5R7emGNKaPUsEifKGObPyCE=
Message-ID: <a8e1da0801161718w573ac941jc83011e63c47ecf@mail.gmail.com>
Date: Thu, 17 Jan 2008 09:18:36 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct class
Cc: "Jarek Poplawski" <jarkao2@gmail.com>, "Greg KH" <gregkh@suse.de>,
       stefanr@s5r6.in-berlin.de, david-b@pacbell.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0801161026090.4431-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0801151703w52df227en42eae85e75d5017f@mail.gmail.com>
	 <Pine.LNX.4.44L0.0801161026090.4431-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 16, 2008 11:27 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 16 Jan 2008, Dave Young wrote:
>
> > The lockdep warining was posted in the below thread, actually, I have
> > built and run this patced kernel for several days, there's no more
> > warnings.
> > http://lkml.org/lkml/2008/1/3/2
>
> Your meaning isn't clear.  Do you mean that your patch doesn't generate
> any lockdep warnings at all?  Or do you mean that it generates a single
> lockdep warning at boot time and then no more warnings afterward?

I means the latter one.

>
> Alan Stern
>
>

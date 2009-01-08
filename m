Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbZAHLhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbZAHLhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 06:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbZAHLhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 06:37:07 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:38099 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbZAHLhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 06:37:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dfoVvMiDVQl9uTM17r7XWGSygvgG0ZyxJ4KcZyq35lhE1ph3geGdyKqnuJLQuqbtfa
         Y+vjAdA7AuZty3q/QMadagFKB3fXNoa7y+cI+bpvf8vt9Z81/prRRUx6z+jji4UMWt0/
         4OenUszJB7E9mDpjh8fZ20If6BeZ/N7nnKvPw=
Message-ID: <8447d6730901080337r190770d5s5eca64720bb7330f@mail.gmail.com>
Date: Thu, 8 Jan 2009 12:37:04 +0100
From: "Davide Rizzo" <elpa.rizzo@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 1/2] Driver for user access to internal timer
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, ben-linux@fluff.org
In-Reply-To: <20090108112959.GB3053@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8447d6730901080205o1a337d4cx867c7b2bd429ceb0@mail.gmail.com>
	 <20090108112959.GB3053@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Davide,
> please don't use drivers/uio/ for things that are no UIO drivers.
>
> Thanks,
> Hans

I thought drivers/uoi is a better choice then driver/misc, because
this driver allows user to access internal hardware to generate PWM
signals.
Otherwise, where do you suggest to put it ?
Davide

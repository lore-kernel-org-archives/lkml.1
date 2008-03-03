Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYCCIke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYCCIke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 03:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYCCIk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 03:40:27 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:13517 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbYCCIk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 03:40:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hghOObLBagIZT/zDkO4MRl0geyI7QU0rmwX03iyH1dl8Y8e/GuuMUky8iCBQ00iuQ9hJENYNXlVgJg8uD8u7P4L5VcQsMjnZH9Raqgcs7qvaHYNNFyTiVgM3Vo/angdoedY6cxcbt1+qREQifmL5osQ/2RNSNF1OTLljo8HVZrU=
Message-ID: <cfd18e0f0803030040l667dd2b7v6298e78c5b21bfec@mail.gmail.com>
Date: Mon, 3 Mar 2008 09:40:24 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: SCHED_IDLE documentation
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Christoph Hellwig" <hch@lst.de>,
       cbe-oss-dev@ozlabs.org, "Jeremy Kerr" <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080303073311.GB5934@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203376368.275756.252634247263.1.gpush@pokey>
	 <200803030612.28039.arnd@arndb.de> <20080303051719.GA26102@lst.de>
	 <200803030721.52869.arnd@arndb.de> <20080303073311.GB5934@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 8:33 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Arnd Bergmann <arnd@arndb.de> wrote:
>
> > If we don't have any man page, what is the actual definition of
> > SCHED_IDLE anyway?
>
> it's rather simple: "it's a priority level even lower priority than nice
> +19".

Some other questions whose answers may be worth including in the man page:

* When was SCHED_IDLE added?  (Actually, who added it?)

* Why was it added?  (What are the particular benefits of the new
sceuling class as opposed to using a very low nice value for
SCHED_OTHER?)

* What's the difference between SCHED_IDLE and SCHED_BATCH?

Cheers,

Michael


-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html

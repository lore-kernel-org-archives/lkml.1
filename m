Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbYAFWr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbYAFWr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 17:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbYAFWrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 17:47:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:11776 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbYAFWrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 17:47:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XtJWbBHwyQnKYWPNqxCjQVffNjHKEPanaQBwpeEiKYiZChm9k/TmC/g60O5DHVzTPrxORmIgJdw4z54y3LuuaPNQTHuapVYaa7BWT1DuKSauBOhJh3OZlDROzOJlTkFu3v+sTUwrOFInByc5uE0o8qC7X7mxPS9cRP7J5VYCq7k=
Message-ID: <9d2cd630801061447w33478ad3p4eb24640e7f8784@mail.gmail.com>
Date: Sun, 6 Jan 2008 23:47:19 +0100
From: "Gregor Jasny" <gjasny@googlemail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [PATCH] vivi driver works only as first device
Cc: "Gregor Jasny" <jasny@vidsoft.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1197270531.5168.5.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071203225610.GS17496@vidsoft.de>
	 <20071206220634.GT17496@vidsoft.de> <1197270531.5168.5.camel@gaivota>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 10, 2007 8:08 AM, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> Thanks for the report. Instead of applying your patch, I decided to
> better analyze the issue, fixing it with the proper solution. The issue
> is that vivi_register changes iminor, but this change were not properly
> returned to the driver.

Any chance to push this into 2.6.24?

Gregor

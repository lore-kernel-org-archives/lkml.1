Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbYGAU3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbYGAU3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbYGAU2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:28:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32788 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbYGAU2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:28:52 -0400
Message-ID: <486A92B5.10008@zytor.com>
Date: Tue, 01 Jul 2008 13:25:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org> <48695871.8000805@zytor.com> <48695F88.9080905@goop.org> <48696167.6050000@zytor.com> <20080701195942.GA76608@atlantis.8hz.com> <20080701202014.GA77013@atlantis.8hz.com>
In-Reply-To: <20080701202014.GA77013@atlantis.8hz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sean Young wrote:
> 
> I was just trying to confirm this with postive and negative tests which 
> is failing. I'm probably being an idiot, please let systematically test
> this.
> 
> This does not seem like the heisenbug category, or is it?
> 

It could easily be something timing-dependent, which might affect only X 
boots out of Y.  Please keep us posted on your testing progress.

It would also be very interesting if you put, say, a WBINVD at the point 
  of label 1:

	-hpa


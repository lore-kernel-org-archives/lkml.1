Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbXCHSlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbXCHSlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933017AbXCHSlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:41:46 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:53288 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010AbXCHSlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:41:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CE+8HYOZE0HYaefh6bv5VSiLVsTcs2etpw7+GYw5Lpfj9XGklLUsbAG6Oj+FDkeMvo7Gl1IkCEuZ/8X2L8t1M60mI5X8J4zjw1siA4LkbUPIoO0z2ka1hbCjHeXd1hR5/DBcWVkIVAqVzy5Zk+3l1XzpNFq7U+KsVM+UnZpo4Zw=
Message-ID: <1defaf580703081041m5bfbef6t41e911b2dc88667a@mail.gmail.com>
Date: Thu, 8 Mar 2007 19:41:39 +0100
From: "Haavard Skinnemoen" <hskinnemoen@gmail.com>
To: NZG <ngustavson@emacinc.com>
Subject: Re: passing function pointers through platform devices?
Cc: "Ben Nizette" <ben.nizette@iinet.net.au>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200703071037.00322.ngustavson@emacinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703061246.29615.ngustavson@emacinc.com>
	 <45EE373B.80606@iinet.net.au>
	 <200703071037.00322.ngustavson@emacinc.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, NZG <ngustavson@emacinc.com> wrote:
> > Once the generic GPIO framework migrates upstream from -mm

It already has:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4c20386c8d0719b42503efe65abe47ad3fb3d711

> I googled extensively and requested information on any current work here
> before I began this project and got zip. (see forwarded email paste)

Your mail seems to be about a gpio userspace interface, which is
something entirely different from an in-kernel API, although I suppose
it should be possible to build a userspace interface on top of the
generic in-kernel API.

If you're looking for a way to do GPIO from a driver, the new generic
GPIO API should offer what you need, assuming it has actually been
implemented on your platform.

Haavard

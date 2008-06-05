Return-Path: <linux-kernel-owner+w=401wt.eu-S1760480AbYFEWjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480AbYFEWjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 18:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYFEWjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 18:39:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40382 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbYFEWjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 18:39:04 -0400
Message-ID: <48486B05.30300@garzik.org>
Date: Thu, 05 Jun 2008 18:39:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] firmware: moving drivers to request_firmware()
References: <20080605.foo@pmac.infradead.org>  <4848648D.8010501@garzik.org> <1212272337.2534.27.camel@shinybook.infradead.org>
In-Reply-To: <1212272337.2534.27.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Thu, 2008-06-05 at 18:11 -0400, Jeff Garzik wrote:
>> Thus, if you are going to be touching the in-tree firmwares at all, it 
>> doesn't make sense to convert from C source to any format other than 
>> native binary.
> 
> I disagree. But feel free to post patches which get applied and prove me
> wrong. I'm not going to object if you want to go convert a few more
> drivers.

IMO, if-and-only-if you are touching driver firmwares, you should not do 
anything but render them into their preferred form.

It is useless churn that increases maintenance annoyances to convert an 
in-tree firmware to something other than the form it's in now, so you 
might as well get it right.

	Jeff



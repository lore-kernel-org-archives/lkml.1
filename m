Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbZDIJyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbZDIJyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbZDIJxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:53:51 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:50352 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbZDIJxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:53:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=emMfTd+SIp4kjZ0k9WbvCYja5fk5v07HH41hsa9oilrW+I/HNcJFVi1bSJPAORyxCe
         nhex7oUVn1FVCrM6+Grvn8LrWriw0OoXhNRKEXBV1LBkIaLjqq/rEuKsonpNzNPkmK23
         Q2Lj6zHm0qInEFoVvBbpKkdgpVvUdN+H+mqyw=
MIME-Version: 1.0
Reply-To: alan-jenkins@tuffmail.co.uk
In-Reply-To: <1239269217.16653.14.camel@marge.simson.net>
References: <1239269217.16653.14.camel@marge.simson.net>
Date: Thu, 9 Apr 2009 10:53:47 +0100
Message-ID: <9b2b86520904090253m5afada22jd32d272da1b733fc@mail.gmail.com>
Subject: Re: 2.6.30.git: USB storage (usbstick) automount woes - bisected
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mike Galbraith <efault@gmx.de>, Alan Stern <stern@rowland.harvard.edu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/9/09, Mike Galbraith <efault@gmx.de> wrote:
> Greetings,
>
> Plugging a USB stick after the first big .30 pull (8e0ee43..c31f403) no
> longer detects/automounts on my opensuse 11.0 x86_64 box.  Bisection
> fingered e6e244b6cb1f70e7109381626293cd40a8334ed3.

Alan Stern posted a test patch here:
<http://lkml.org/lkml/2009/4/8/735>.  I can confirm that this fixes
the problem.

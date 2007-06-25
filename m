Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbXFYOTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbXFYOTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 10:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbXFYOTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 10:19:34 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:25098 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753509AbXFYOTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 10:19:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jEUs2NSTQlmdnZGF3FHOrnAhmXQK/4BHCjNMGEdJW/5GSVVatGrkEC60A/Qz+davy6E8Repeu/84uShK2tqiryO+fFnToghdI6hPBPjAnBtyN2ukmR8QrBerOEVdsaJHXEvwG1mqU29kWvLvDdp1cgZfSDaF4v6hMcaHaQEe/UY=  ;
X-YMail-OSG: dqajOQUVM1nCdBbw2IAD8jllYD6uXQNJ9nE20pUJB0YmWld6Ja2GBzpjUkkYin.2Fr3xDBTmvemXeRNq8x8DadK0rg_TbCKVeRyqOkAC2kSyJVE31w--
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] Export usb_gadgetfs.h to userspace
Date: Mon, 25 Jun 2007 07:04:55 -0700
User-Agent: KMail/1.9.6
Cc: linux-usb-devel@lists.sourceforge.net,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
References: <11827637791662-git-send-email-hskinnemoen@atmel.com>
In-Reply-To: <11827637791662-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706250704.55735.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 June 2007, Haavard Skinnemoen wrote:
> The gadgetfs test program from http://www.linux-usb.org/gadget/
> depends on it. I assume most other users of gadgetfs needs this header
> too.

There's already a patch in the 2.6.23 queue which moves this
to <linux/usb/gadgetfs.h> and exports it from there:

   http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6
	/gregkh-03-usb/usb-export-linux-usb_gadgetfs-as-linux-usb-gadgetfs.h.patch

(URL is manually line wrapped).

- Dave

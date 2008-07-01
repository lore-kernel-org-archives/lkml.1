Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbYGAQW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbYGAQW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbYGAQWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:22:50 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:27445 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751842AbYGAQWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:22:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AfSuHvlmn17TxCSqdR8l0Dhpm5bglpgFqIk8flkF78oKHdXXThofLy7eMjI27RKsC9++KCZ0B5YwFZvDRHwyQHExLrguhO7f9cNXqfUNJmZ8CrJ3yrxN8j1ahkdPvdH1aeMbKm/qgY7/pjR0w8midsVHKsx1jgPwxPYBpkRoPMM=  ;
X-YMail-OSG: tm1GowAVM1nCpvSgg3oNBrqO6FQrWor3ISmlR.MVp_LkIBxP62wYFpYcndtASjU3L_d4fbrFo_yq5vaJ6.eRMaG5vbTocWMDDfx5s3h8gupnLRR32IAER7BUceEekgaYfQ8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: fix interrupt disabling for HCDs with shared interrupt handlers
Date: Tue, 1 Jul 2008 09:22:47 -0700
User-Agent: KMail/1.9.9
Cc: Stefan Becker <Stefan.Becker@nokia.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <Pine.LNX.4.44L0.0807011005430.2780-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0807011005430.2780-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807010922.47464.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2008, Alan Stern wrote:
> > -     struct usb_hcd          *hcd = __hcd;
> > -     int                     start = hcd->state;
> > +     struct usb_hcd          *hcd  = __hcd;
> > +     unsigned int            flags = 0;
> 
> flags must be unsigned long.  You don't have to initialize it to 0.

... and use just tabs for those internal indents, not spaces!

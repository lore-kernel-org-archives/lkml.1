Return-Path: <linux-kernel-owner+w=401wt.eu-S1764331AbXF1G6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764331AbXF1G6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 02:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759486AbXF1G6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 02:58:33 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:33712 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758760AbXF1G6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 02:58:32 -0400
Message-ID: <46835C16.9020700@kernel.org>
Date: Wed, 27 Jun 2007 23:58:30 -0700
From: Josh Triplett <josh@kernel.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: dave young <hidave.darkstar@gmail.com>,
       Chris Shoemaker <c.shoemaker@cox.net>,
       Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] CodingStyle: Add information about trailing whitespace.
References: <1182967160.8970.108.camel@josh-work.beaverton.ibm.com>  <20070627180552.GA746@pe.Belkin>  <Pine.LNX.4.64.0706280015320.11120@fbirervta.pbzchgretzou.qr>  <a8e1da0706272300q3aee30der5349e85055f62a8e@mail.gmail.com>  <46835047.8080600@kernel.org> <a8e1da0706272329j42997c3eh49a1b20df5892a0e@mail.gmail.com> <Pine.LNX.4.64.0706280850470.22579@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706280850470.22579@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jun 28 2007 06:29, dave young wrote:
>> IMHO, another  cause of trailing whitespace is human error, for
>> example long lines breaking will easy to cause the first line with one
>> traling whitespace (original space between the last two words).
> 
> Most common errors (to me) are:
> 
>  - hit return+tab too quickly that it interchanges, hence producing
>    the unwanted \t\n
>  - hit return+return to start a new paragraph of code;
>    the intermediate line remains indented if autoindent is on.

Interestingly, emacs gets that case right: when you hit enter it places the
cursor at the properly indented insertion point, but if you leave the line
without typing anything it does not leave the indentation.  I thought I
remembered vim doing the same thing, but I just tested and it appears not.  It
seems to avoid leaving subsequent lines indented, but not the first one.

- Josh Triplett


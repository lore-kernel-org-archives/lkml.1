Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZK3R4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZK3R4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbZK3R4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:56:33 -0500
Received: from mail.perches.com ([173.55.12.10]:1192 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbZK3R4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:56:32 -0500
Subject: Re: warning: massive change to conditional coding style in net?
From: Joe Perches <joe@perches.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
In-Reply-To: <4B13A025.7000103@gmail.com>
References: <4B13A025.7000103@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 09:56:38 -0800
Message-ID: <1259603798.29779.293.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 05:36 -0500, William Allen Simpson wrote:
> Over the past several days, David Miller (with help from Joe Perches)
> made sweeping changes to the format of conditional statements in the
> net tree -- the equivalent of mass patches that change spaces.
> This makes writing patches for multiple versions of the tree very
> difficult, and will make future pullups problematic.

If it makes getting tcp cookies accepted difficult,
a reversion is simple.  That style isn't as important.

I think writing a single set of patches for multiple
versions of linux is not feasible.  Feature changes
occur in kernel source daily.

> 	if (condition
> 	    && condition
> 	    && (condition
> 	        || condition
> 	        || condition)) {

The above is my personally preferred style.

> 	if (condition &&
>              condition && (condition || condition ||
> 	    condition)) {

Except for the odd spacing, this is the significant
majority of net/ style.

The leading style was < 10%.  It's less now.

> Miller (with Perches) changed hundreds (thousands?) of these to
> trailing form.  This results in a number of hilarious examples --
> lines with both leading and trailing, lines with only &&, etc.

Nearly all existing.



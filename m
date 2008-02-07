Return-Path: <linux-kernel-owner+w=401wt.eu-S935242AbYBGWzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935242AbYBGWzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759337AbYBGWzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:55:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40397 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758909AbYBGWzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:55:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Date: Thu, 7 Feb 2008 23:53:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
References: <20080205190600.GB11613@elf.ucw.cz> <200802072340.06138.rjw@sisk.pl> <47AB89CB.7010908@zytor.com>
In-Reply-To: <47AB89CB.7010908@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802072353.51092.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 7 of February 2008, H. Peter Anvin wrote:
> Rafael J. Wysocki wrote:
> > -	rep; stosl
> > +	rep
> > +	stosl
> 
> Yuck!
> 
> Please don't perpetuate the braindamage that this is two instructions. 
> It's one instruction with a modifier;

Sure, it is.

> the fact that gas wants a separator is broken enough as it is.

[Well, the newline is a separator too.]  I'll keep it in one line if you want
that.

Rafael

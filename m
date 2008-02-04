Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbYBDBLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbYBDBLm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 20:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbYBDBLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 20:11:32 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:63886 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754808AbYBDBLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 20:11:31 -0500
Date: Mon, 4 Feb 2008 10:10:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linux-sh <linux-sh@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] SH/Dreamcast - fix regressions, whitespace and memory leaks in Maple Bus driver
Message-ID: <20080204011034.GA22021@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	linux-sh <linux-sh@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <1202068847.6262.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202068847.6262.7.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 08:00:47PM +0000, Adrian McMenamin wrote:
> From: Adrian McMenamin
> 
This is useless if you are submitting the patch, especially if you're
missing a mail address.

> This patch fixes the regression noted here:
> http://lkml.org/lkml/2008/1/26/189 as well as whitespace issues in the
> previous commit of this driver and the memory leaks noted here:
> http://lkml.org/lkml/2008/2/2/143 (as well as one or two other minor
> cleanups).
> 
The subject notes 3 specific things that are being addressed, but you've
rolled this all in to one patch which makes it utterly impossible to
figure out what you're actually fixing. At the very least, split this in
to 3 different patches, each dealing with one of the things noted in the
subject. The fact that regressions is plural also suggests you may want
to split this down in to smaller patches that deal with specific
regressions if they are not directly related.

> Signed off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> 
Do not invent new sign-off tags, see Documentation/SubmittingPatches.
Scripts do end up having to parse this stuff.

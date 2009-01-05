Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbZAEBAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbZAEBAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 20:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbZAEBAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 20:00:04 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:56352
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbZAEBAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 20:00:01 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
Date: Sun, 4 Jan 2009 18:59:56 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200901020207.30359.rob@landley.net> <200901041303.12687.rob@landley.net> <49611E88.6010204@zytor.com>
In-Reply-To: <49611E88.6010204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901041859.57645.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 January 2009 14:39:36 H. Peter Anvin wrote:
> Rob Landley wrote:
> > C) The only calculation which can overflow 64 bits (the ADJ32 one) turns
> > out not to need arbitrary precision math, just 72 bits, and if it ever
> > uses more than 32 then bottom 32 are all zero before the divide so you
> > can do it in three lines.
>
> ... for the current code (32 bits).  When we get an overflow-less 64-bit
> implementation, this code will have to be redone, which is not true for
> a properly done implementation.

One extra mask and add is a strange definition of "redone", but I can add it 
now if you like.  (I'd personally prefer to wait for something to actually 
need it, but...)

> 	-hpa

Rob

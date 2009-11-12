Return-Path: <linux-kernel-owner+w=401wt.eu-S1751429AbZKLKFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbZKLKFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 05:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbZKLKFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 05:05:35 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:40899 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbZKLKFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 05:05:35 -0500
Date: Thu, 12 Nov 2009 11:05:38 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Anders Larsen <al@alarsen.net>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/4] fs/qnx4: decrement sizeof size in strncmp
In-Reply-To: <1258017918l.26867l.0l@i-dmzi_al.realan.de>
Message-ID: <Pine.LNX.4.64.0911121105310.19166@ask.diku.dk>
References: <Pine.LNX.4.64.0911120849260.16627@ask.diku.dk>
 <1258017918l.26867l.0l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009, Anders Larsen wrote:

> On 2009-11-12 08:49:44, Julia Lawall wrote:
> > As observed by Joe Perches, sizeof of a constant string includes the
> > trailing 0.  If what is wanted is to check the initial characters of
> > another string, this trailing 0 should not be taken into account.  If an
> > exact match is wanted, strcmp should be used instead.
> 
> Good catch.
> However, in this case an exact match (with the string ".bitmap") is what
> is needed, so
> 
> NAK
> 
> Will you cook up a new patch changing strncmp to strcmp?

Sure.

julia

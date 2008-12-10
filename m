Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbYLJWwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbYLJWwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 17:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYLJWwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 17:52:30 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:29562 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751448AbYLJWw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 17:52:29 -0500
Date: Thu, 11 Dec 2008 07:50:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Julia Lawall <julia@diku.dk>
Cc: dmitri.vorobiev@movial.fi, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 15/28] arch/sh: Drop return value from platform_driver remove functions
Message-ID: <20081210225044.GA2216@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Julia Lawall <julia@diku.dk>, dmitri.vorobiev@movial.fi,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0812101737120.21998@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812101737120.21998@ask.diku.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 05:37:35PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The return value of the remove function of a driver structure, and thus of
> a platform_driver structure, is ultimately ignored, and is thus
> unnecessary.  This patch removes the return value for the remove function
> stored in a platform_driver structure.  For the files in this patch, the
> return values are always 0.
> 
> A simplified version of the semantic patch that makes this change is as
> follows: (http://www.emn.fr/x-info/coccinelle/)
> 
Interesting definition of simplified ;-)

Applied, thanks.

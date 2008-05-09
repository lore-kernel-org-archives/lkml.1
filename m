Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYEIKJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYEIKJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 06:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbYEIKJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 06:09:38 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:40944 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750768AbYEIKJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 06:09:37 -0400
Date: Fri, 9 May 2008 19:08:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SH: catch negative denormal_subf1() retval in denormal_add()
Message-ID: <20080509100825.GA6069@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Roel Kluin <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
References: <4806CB92.6010402@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4806CB92.6010402@tiscali.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 06:01:22AM +0200, Roel Kluin wrote:
> 'ix' is unsigned but denormal_subf1() may return a negative int.
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

I'm at a loss as to why you couldn't be bothered CC'ing the appropriate
list or anyone else on this, when you seem to have worked it out for
other patches.

Anyways, applied.

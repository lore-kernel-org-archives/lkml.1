Return-Path: <linux-kernel-owner+w=401wt.eu-S1750892AbXBNLMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750892AbXBNLMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 06:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbXBNLMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 06:12:13 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:52243 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbXBNLML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 06:12:11 -0500
Date: Wed, 14 Feb 2007 16:42:09 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Gerd Hoffmann <kraxel@suse.de>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>
Subject: Re: Will smp alternative try to patch init text also?
Message-ID: <20070214111209.GB3393@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070214104338.GA3393@in.ibm.com> <45D2E9B3.8080008@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D2E9B3.8080008@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 11:51:31AM +0100, Gerd Hoffmann wrote:
> Vivek Goyal wrote:
> > So what happens if somebody builds a SMP kernel and runs on a UP machine.
> > Later it hotplus one CPU. Then kernel will switch to SMP mode. Looking
> > at the code it looks like it will also try to patch init text which is
> > no more there and will corrupt something else? 
> 
> There are range checks for both kernel (_text -> _etext) and modules
> (.text section).  Anything outside isn't patched.
> 

Oh... I missed that. Thanks.

Vivek

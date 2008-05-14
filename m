Return-Path: <linux-kernel-owner+w=401wt.eu-S1760754AbYENPwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760754AbYENPwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYENPwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:52:22 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:7173 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbYENPwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:52:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=PULjHpMdU7cPgW52HDsRqBx6/2wQPT8h3oo3qctCFn5jGmYH9E9CjrPtVl+emHE1nfTfk8YNZszk5weOVQdwGuVmd3mR1mcV46z7WtQVPipgmfmDY1fB9a30q2Qi4HNXgGLwf09+f07DPheAO8Ea4goTnm/B8TUSKO9ekpug4iI=
Date: Wed, 14 May 2008 11:52:18 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Byron Bradley <byron.bbradley@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       akpm@linux-foundation.org, nico@cam.org, buytenh@wantstofly.org
Subject: Re: 2.6.26-rc2-mm1: oops on ARM while registering GPIO Keys
Message-ID: <20080514115114.ZZRA012@mailhub.coreip.homeip.net>
References: <alpine.DEB.1.00.0805141620080.3865@gamma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0805141620080.3865@gamma>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 04:34:41PM +0100, Byron Bradley wrote:
> Testing on a QNAP TS-209 (ARM, Marvell Orion 88F5182 SoC). GPIO Keys works 
> correctly on 2.6.26-rc2 but panics on 2.6.26-rc2-mm1. If nobody knows the 
> cause of this I can look into it/bisect later.
> 

Yeah, it seems I applied the wrong version of the debouncing patch.
Just revert git-input from -mm for now.

-- 
Dmitry

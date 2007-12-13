Return-Path: <linux-kernel-owner+w=401wt.eu-S933341AbXLMWoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341AbXLMWoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761977AbXLMWoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:44:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:31741 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbXLMWoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:44:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=R3MXLhH0igSW/xLFHSFtWkPO2R+fHKLemKx3w+UZrY7rn13AjoJACHOvT8IL6cOXBGI79SJ8nnQt6Kcwbs0MAl99W31q1/L2n6vqf4IuZeNM3fmUi3ogDvbO0OaiMaBREO736dCODWWt9xOzlIImCG0GB02tS7JQ7puHM3F/gM0=
Subject: Re: RFC: remove __read_mostly
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: bunk@kernel.org, linux-kernel@vger.kernel.org,
       linux-arch <linux-arch@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <20071213.143246.175833292.davem@davemloft.net>
References: <20071213222044.GH21616@stusta.de>
	 <20071213.143246.175833292.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 14:44:15 -0800
Message-Id: <1197585855.898.33.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-13 at 14:32 -0800, David Miller wrote:
> From: Adrian Bunk <bunk@kernel.org>
> Date: Thu, 13 Dec 2007 23:20:44 +0100
> 
> > My question is:
> > Is there anywhere in the kernel a case where __read_mostly brings a 
> > measurable improvement or can it be removed?
> 
> Yes, on SMP when read-mostly objects share cache lines
> with other objects which are frequently written to.
> 
> That is the whole reason we created __read_mostly

I'm curious if anyone has been looking into replacing the __read_mostly
approach with Mathieu's immediate values patchset.  Wouldn't they solve
the cacheline sharing as well (perhaps more eficiently even with trading
some icache for dcache)?

Harvey


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYDII6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYDII6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYDII6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:58:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57552 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYDII6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:58:37 -0400
Date: Wed, 9 Apr 2008 11:03:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matti Aarnio <matti.aarnio@zmailer.org>,
       Zhao Forrest <forrest.zhao@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       discuss@x86-64.org, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       ak@suse.de
Subject: Re: Does Linux have plan to support memory hole remapping?
Message-ID: <20080409090306.GF19010@one.firstfloor.org>
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com> <87iqyro3rc.fsf@basil.nowhere.org> <20080409083700.GU3700@mea-ext.zmailer.org> <20080409085440.GB32466@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409085440.GB32466@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> having said that - but we'll still consider sane looking patches that 
> allow the remapping of otherwise inactive RAM. 

I doubt there is any way to do this sanely in the kernel. Usually you 
would need to move either the PCI hole (which is hard or impossible) or all 
RAM beyond it (potentially breaking SMM assumptions and causing other problems). 

Normally the memory controllers don't have a way to just remap pieces because
that would need much hardware in critical paths. 
 
The only half way sane way to attack this without vendor support 
would be LinuxBIOS imho.

-Andi


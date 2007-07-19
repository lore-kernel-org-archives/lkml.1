Return-Path: <linux-kernel-owner+w=401wt.eu-S1751984AbXGSMUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbXGSMUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764400AbXGSMTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:19:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762695AbXGSMTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:19:48 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH] [19/58] x86_64: Don't use softirq save locks in smp_call_function
Date: Thu, 19 Jul 2007 14:19:43 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <20070719095504.376B614E06@wotan.suse.de> <a781481a0707190516m651cc7bbs7ac8fc3510d8f5d6@mail.gmail.com>
In-Reply-To: <a781481a0707190516m651cc7bbs7ac8fc3510d8f5d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191419.44020.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 14:16:48 Satyam Sharma wrote:

>
> > Can't do a WARN_ON unfortunately because it could trigger in the
> > panic case.
> 
> But this is not true at all. This function doesn't come anywhere
> on the panic codepath.


You're wrong.

-Andi



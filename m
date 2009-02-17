Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbZBQVRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbZBQVRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZBQVR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:17:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbZBQVR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:17:27 -0500
Date: Tue, 17 Feb 2009 13:16:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Junio C Hamano <gitster@pobox.com>,
       Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?Q?=22S=2E=C3=87a=C4=9Flar_Onur=22?= <caglar@pardus.org.tr>
Subject: Re: [PATCH] Add *.rej to .gitignore
In-Reply-To: <499B1729.5040802@goop.org>
Message-ID: <alpine.LFD.2.00.0902171315400.21686@localhost.localdomain>
References: <499B1729.5040802@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Feb 2009, Jeremy Fitzhardinge wrote:
> 
> (This effectively reverts 1f5d3a6b6532e25a5cdf1f311956b2b03d343a48)

I really dont' think we should ignore .rej files. 

They are _error_ cases, after all. People want to know about them. And if 
you don't want to see them, you should remove them.

		Linus

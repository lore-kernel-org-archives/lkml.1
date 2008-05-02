Return-Path: <linux-kernel-owner+w=401wt.eu-S964957AbYEBWrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964957AbYEBWrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932204AbYEBWq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:46:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60006 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbYEBWq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:46:57 -0400
Message-ID: <481B99A3.3080603@zytor.com>
Date: Fri, 02 May 2008 15:45:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Carlos R. Mafra" <crmafra@ift.unesp.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/time.c: Silence gcc warning 'integer constant
 to large for long type'
References: <200805021858.m42Iw4Lj025952@tazenda.hos.anvin.org> <alpine.LFD.1.10.0805021407030.5994@woody.linux-foundation.org> <481B888F.3070302@zytor.com> <alpine.LFD.1.10.0805021515120.5994@woody.linux-foundation.org> <alpine.LFD.1.10.0805021528080.5994@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805021528080.5994@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Make the timeconst.h file just contain sane macros. No preprocessor games 
> etc. Just make it say
> 
> 	#define USEC_TO_HZ_MUL32 ..correct-value-here..
> 
> and not even generate macros with values that cannot be used (ie >64 
> bits).
> 

OK.  I was being too general, I guess (holding out for stuff like doing 
this in 64-bit space which would require 128-bit constants, which gcc 
*does* support on 64-bit platforms.)

I'll have a clean patch shortly.

	-hpa

Return-Path: <linux-kernel-owner+w=401wt.eu-S938069AbXGTXgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938069AbXGTXgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbXGTXgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:36:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbXGTXgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:36:38 -0400
Subject: Re: [PATCH] x86: Create clflush() inline, remove hardcoded wbinvd
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200707202119.l6KLJwcd004205@tazenda.hos.anvin.org>
References: <1184885740.16311.19.camel@t60>
	 <200707202119.l6KLJwcd004205@tazenda.hos.anvin.org>
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 20 Jul 2007 20:37:31 -0300
Message-Id: <1184974651.16311.35.camel@t60>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 14:19 -0700, H. Peter Anvin wrote:
> Create an inline function for clflush(), with the proper arguments,
> and use it instead of hard-coding the instruction.
> 
> This also removes one instance of hard-coded wbinvd, based on a patch
> by Bauder de Oliveira Costa.
Hey, Who's that guy that got a name so close to mine? ;-)

> 
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Glauber de Oliveira Costa <gcosta@redhat.com>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>



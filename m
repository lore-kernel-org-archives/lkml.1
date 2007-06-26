Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbXFZPik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbXFZPik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758197AbXFZPiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:38:23 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57396 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034AbXFZPiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:38:22 -0400
Message-ID: <46813020.1010103@zytor.com>
Date: Tue, 26 Jun 2007 11:26:24 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: David Woodhouse <dwmw2@infradead.org>,
       Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, david@lang.hm,
       schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org
Subject: Re: Linux Kernel include files
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de> <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm> <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de>
In-Reply-To: <20070622150038.GN23017@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> 
> It would certainly help if Joerg would tell what exactly breaks, but I 
> spot one likely problem in include/asm-i386/types.h:
> 
> #if defined(__GNUC__) && !defined(__STRICT_ANSI__)
> typedef __signed__ long long __s64;
> typedef unsigned long long __u64;
> #endif
> 
> It might make sense to remove the #if and simply require that
> a C compiler under Linux must know about the C99 "long long"?
> 

Yes.

	-hpa


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbZAMS43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbZAMS43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZAMS4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:56:12 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:42906 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbZAMS4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:56:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p2CFy7zhCDDM4/2ffS1tkpGfqTR2TM0CkhKGyoPGczZFULlqOpYmr+pCsf3B5MD2k8
         vf1+Q1A3kibCO92g2GtFJzcohIn4TOl2Rzk8fubaoOc5woVWLaEwekYDY9hzIi6WQdCa
         uicHPcPH5JYKs2cmuqGcMB7TNxqdMtLOndfKk=
Date: Tue, 13 Jan 2009 21:56:08 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - fix export private data to
	userspace
Message-ID: <20090113185608.GD14470@localhost>
References: <20090113183456.GA14470@localhost> <1231871832.16221.1.camel@brick> <20090113185013.GB14470@localhost> <496CE36B.1030604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496CE36B.1030604@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Tue, Jan 13, 2009 at 10:54:35AM -0800]
| Cyrill Gorcunov wrote:
| > 
| > I was concerning more about lilo side, is it use this param.
| > So here is a link
| > 
| > 	http://lists.linuxcoding.com/kernel/2006-q3/msg18665.html
| > 
| > is seems LILO has it's own definition for COMMAND_LINE_SIZE.
| > On the other hand it touches boot protocol. Peter should know
| > if it safe to hide/change COMMAND_LINE_SIZE. Peter?
| > 
| 
| Current x86 kernels export the command line size through the bzImage
| header, and as such COMMAND_LINE_SIZE should not be used by userspace.
| 
| I can't speak for other architectures.
| 
| 	-hpa
| 
| -- 
| H. Peter Anvin, Intel Open Source Technology Center
| I work for Intel.  I don't speak on their behalf.
| 

Thanks Peter!

		- Cyrill -

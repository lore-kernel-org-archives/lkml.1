Return-Path: <linux-kernel-owner+w=401wt.eu-S1765333AbYBALIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765333AbYBALIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764435AbYBALIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:08:23 -0500
Received: from hu-out-0506.google.com ([72.14.214.237]:10079 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764329AbYBALIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=n4ICB02FtEpLxlhYwPdrvG/de6jiDUbcDfJ4zz2x0ScaLFycP20XcnvCNDIrUrTlPtH92JcX7KeWUyJFursrlyJzEBdW6/FlT0pyLuyKQvgkTIrz45P5CGlNLvVMNfo6Ayc0nZdmSraesbKOK5GVIQ+x8qhgvfVBOKe75v3YSfE=
Subject: Re: [PATCH] x86: sparse errors from string_32.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080201105624.GD27178@elte.hu>
References: <1201846516.23523.87.camel@brick>
	 <20080201105624.GD27178@elte.hu>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 03:07:55 -0800
Message-Id: <1201864075.23523.106.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-01 at 11:56 +0100, Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> >  		case 1:
> > -			*(unsigned char *)s = pattern;
> > +			*(unsigned char *)s = pattern & 0xff;
> 
> i've applied your fix - but wouldnt it be cleaner to just cast the 
> pattern variable to unsigned char instead?

I'm not sure, I went with this solution because of the explicit length
being tested in the case statements.  The compiler can see it's all
constant at this point anyway...if you want a cast-patch instead, just
ask.

Harvey


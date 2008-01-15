Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYAOKPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYAOKPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYAOKPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:15:04 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:62175 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbYAOKPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:15:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OGs6EAFWmT2vMSLEun76nK4Z2ct0c2I5V5YFQk9i3oxIbUKPrpr2+LkMFusFIMpFFps87eO9tAUHx/LWlcZozrwrGXpbhsgmuvYS1faWxLq+P5+esQRnXa0H4eDAiOCcui4VjNSeYvOV7eGGLmngzdY3dYPXmKDcb7uWuCjC+1U=
Subject: Re: [PATCH] [13/31] CPA: Use macros to modify the PG_arch_1 page
	flags in change_page_attr
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
In-Reply-To: <200801151106.41855.ak@suse.de>
References: <200801141116.534682000@suse.de>
	 <20080114221645.90C5D14F83@wotan.suse.de> <1200389391.16794.12.camel@brick>
	 <200801151106.41855.ak@suse.de>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 02:15:02 -0800
Message-Id: <1200392102.16794.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-15 at 11:06 +0100, Andi Kleen wrote:
> On Tuesday 15 January 2008 10:29:51 Harvey Harrison wrote:
> > On Mon, 2008-01-14 at 23:16 +0100, Andi Kleen wrote:
> > > Instead of open coding the bit accesses uses standard style
> > > *PageDeferred* macros. 
> > > 
> > 
> > Any reason these couldn't be static inlines in a shared header?
> 
> The whole usage of that bit is private to the file

True if pageattr_32|64.c get merged, not one I have looked at yet,
but wouldn't a static inline in the files then be better for the
typechecking?

Harvey


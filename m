Return-Path: <linux-kernel-owner+w=401wt.eu-S1760341AbYARCCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341AbYARCCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbYARCCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:02:09 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:42324 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbYARCCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:02:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Uw84ljpFjJ+x2lwVNGfNPV/GiDVaKPoHlOCIeylLTYOkGDWTsv4gj9RHhJNnVsEbgwdNV2R6RHNEKNkDfRaP6Crm7FwBfWscay5eL+ji7dKWG0d5TnYK+tO0NeFbAeUa9jl1MtJZtVZt5klRYdKFIZpkKKUpyIQyAj9ahKlDQ4k=
Subject: Re: [PATCH] x86: Use v8086_mode helper, trivial unification
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <479002B6.9030607@zytor.com>
References: <1200611078.5724.46.camel@brick>	<478FDE76.3070309@zytor.com>
	 <1200612389.5724.63.camel@brick>	<478FF9F3.9030604@zytor.com>
	 <1200618952.5724.85.camel@brick>
	 <20080118013712.4090526FA0B@magilla.localdomain>
	 <479002B6.9030607@zytor.com>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 18:02:07 -0800
Message-Id: <1200621727.5724.96.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-17 at 20:36 -0500, H. Peter Anvin wrote:
> Roland McGrath wrote:
> > It's indeed true that &pt_regs is truly the esp value for x86-32
> > kernel-mode trap frames.  Because this nonobvious calculation is 
> > only right for a kernel mode pt_regs and not for a user-mode one,
> > I think it would be better to use a name for the inline/macro that
> > makes this quite clear, rather than one so generic as "stack_addr".
> 
> Indeed.  This was certainly highly nonobvious in the current code.
> 

What do you think of kernel_sp()

Harvey


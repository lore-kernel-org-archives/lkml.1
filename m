Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbZLaM4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbZLaM4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 07:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZLaM4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 07:56:32 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49761 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbZLaM4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 07:56:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=GdYyJF0ntx3aCbAHidqoaL/vfHT4Cwg4+a7P10Q5ySLdHnvQry0PEtfnmTpAS+8Kg0
         DZAPWouL2G1/X91UJFURiVq5tzp7FoXx4gETgG/z5YAp571OfvawY2Nc6V0zKhYzg7pa
         SgCYAr9GPQ3NbP03TkUJOnfuUzXMyn5qwZUYw=
Date: Thu, 31 Dec 2009 13:56:24 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20091231125624.GA14666@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20091231120322.GA23326@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091231120322.GA23326@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 01:03:22PM +0100, Ingo Molnar wrote:
> Shaun Ruffell (1):
> 
>       dma-debug: Do not add notifier when dma debugging is disabled.

Looks like that last one breaks powerpc allyesconfig builds: 

http://marc.info/?l=linux-next&m=126221673819746&w=2

-- 
Regards/Gruss,
    Boris.

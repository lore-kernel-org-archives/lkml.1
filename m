Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbYKLAqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbYKLAqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbYKLAfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:35:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:24121 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbYKLAfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:35:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=G7bLkkT8RsYeUPGqy6JfLaM8WM5qFzDVNvB27yjpUS0CmWzgN6HnS7BnQjy8CS8Prq
         XToWo8Ww2k6rwDLdp3V1J4VE2ZutRCpHenDCmUoL2qanS7G3wfG2YFu8Y6BuiTWhXG6w
         uLxejxrO8CGH6vUV16s9fdqjcPngj/3OmDBk0=
Message-ID: <b9df5fa10811111635i1154a9a3la5b9fbcfef4df9dc@mail.gmail.com>
Date: Wed, 12 Nov 2008 06:35:19 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] x86: Fixing improper annotation.
Cc: "Rufus & Azrael" <rufus-azrael@numericable.fr>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081111104112.GC10554@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49193D1A.9040000@numericable.fr> <20081111103649.GA10554@elte.hu>
	 <491962FE.1020805@numericable.fr> <20081111104112.GC10554@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/08, Ingo Molnar <mingo@elte.hu> wrote:

>
> okay - so i wont apply them until the full scope of the problems here
>  is mapped. We might be best off by marking xsave_cntxt_init() non-init
>  altogether for the time being?
But, it's been called from an __init section, it will also trigger an
warning too. So, it
 will remain as it was. If we goes to hunt these warnings ( I mean
we've to replace __init __alloc_bootmem() with __cpuinit
__alloc_bootmem() ) , it's not certain when it will stop. Likely , we
need to replace a lots of __init with __cpuinit.

Rakib
>
>         Ingo
>

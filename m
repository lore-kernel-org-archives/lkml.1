Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYAEMsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYAEMsN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 07:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYAEMr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 07:47:58 -0500
Received: from smtp101.plus.mail.re1.yahoo.com ([69.147.102.64]:34820 "HELO
	smtp101.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754079AbYAEMr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 07:47:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=Ix7cl839/BynocPd5NOOniTZEEf04pzoes8puVIqF6z3NXVhEpliRCyLtzPadN/6k4DsvTjPfr8UTEfgAnL4xH6WA6eFpbNgvwCkBBMmkBpuBNPBMmhMHIBwnwTgLBVz6pHiER5L7tc6qPVBgXAdfBmxrjGi0FsWStYrNk82BOo=  ;
X-YMail-OSG: HUQ9MBIVM1nFTbYzerH_CcLxbfKR7a6tf5OLX0_BDCuzg1nVxbJaEVWlMg89N2lM8pEEyyc4DA--
Date: Sat, 5 Jan 2008 13:45:01 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 02/10] ide-floppy: move ide-floppy struct and
	macro defs into its own header. While at it
Message-ID: <20080105124501.GA5704@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-2-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-3-git-send-email-bbpetkov@yahoo.de> <200801042349.09964.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801042349.09964.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 11:49:09PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
Hi Bart,

> Hmm, contrary to ide-cd.c case there doesn't seem to be a need currently for
> moving code out of ide-floppy.c (and this patch series doesn't change that).
?, you mean this patch series _does_ change that, meaning it moves the struct
defs into a header file. Do i get this correctly that we don't need the header
file and the struct defs should remain in the .c file?

> Besides it would be better to just remove some structs like it has been done
> with i.e. struct atapi_capabilities_page in ide-cd.c case [1] because:

[...]

> typedefs are evil (exceptions are rare) and should die :)
> 

i'm redoing them right now against ide-2.6.git and will post when ready. By the
way, i have done some more cleanups in the meantime. Should i include them into
this series or send them later?

-- 
Regards/Gruﬂ,
    Boris.

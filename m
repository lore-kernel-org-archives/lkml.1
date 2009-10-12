Return-Path: <linux-kernel-owner+w=401wt.eu-S1751564AbZJLFGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbZJLFGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 01:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbZJLFGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 01:06:17 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:55348 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbZJLFGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 01:06:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=efImL9f5PAICVQGfRFmpTAkwFSWmKIYCTFoytrFQdqBWz0KL/BGon42rUn6Ps6jiDx
         HKBLapzU1RP1tdPgtHML+XgFTSbO4Bw1ubg65csYpJIlyjDw3oa4IPmCGoA2BY7ApcCr
         SFjZiPtcmP68be1AnXWFBv5QTHy07bdGQNmgo=
Date: Mon, 12 Oct 2009 07:05:34 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the i7core_edac tree with Linus'
 tree
Message-ID: <20091012050534.GC7629@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Ingo Molnar <mingo@elte.hu>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091012142328.710881fe.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091012142328.710881fe.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 02:23:28PM +1100, Stephen Rothwell wrote:
> Today's linux-next merge of the i7core_edac tree got a conflict in
> arch/x86/kernel/cpu/mcheck/mce.c between commit
> f436f8bb73138bc74eb1c6527723e00988ad8a8a ("x86: EDAC: MCE: Fix MCE
> decoding callback logic") from Linus' tree and commit
> 699a7dbe1ffdf4b25c1475e45590b181c3e23087 ("edac_mce: Add an interface
> driver to report mce errors via edac") from the i7core_edac tree.

The current way Ingo suggested is using an atomic notifier instead
from within print_mce to convey MCE info to an EDAC driver, see
http://marc.info/?l=linux-kernel&m=125455310112745&w=2

Ingo, what are your plans with that? I'm guessing the .33 timeframe?

Thanks.

-- 
Regards/Gruss,
    Boris.

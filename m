Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbYK1Npq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbYK1Npq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 08:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYK1Npg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 08:45:36 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:48136 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbYK1Npf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 08:45:35 -0500
Date: Fri, 28 Nov 2008 13:45:25 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com,
       matthew@wil.cx
Subject: Re: [PATCH v3] relatime: Make relatime smarter
Message-ID: <20081128134525.GB5058@srcf.ucam.org>
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127163535.775729bf@lxorguk.ukuu.org.uk> <20081127164754.GC22963@srcf.ucam.org> <20081127165929.GA23366@srcf.ucam.org> <20081127191547.7c9cf6d2@lxorguk.ukuu.org.uk> <20081128111630.GG6138@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128111630.GG6138@shareable.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 11:16:30AM +0000, Jamie Lokier wrote:
> Alan Cox wrote:
> > > +	relatime_interval=
> > > +			[FS] relative atime update frequency, in seconds.
> > > +			(default: 1 day: 86400 seconds)
> > 
> > What about leap seconds  ;)
> 
> More generally - is the relatime_interval in "monotonic" seconds, or
> in gettimeofday seconds which are changed by clock updates?

If this is actually a problem people in the real world are worried 
about, I think there's been a fundamental failure in the human race.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

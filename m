Return-Path: <linux-kernel-owner+w=401wt.eu-S1759642AbXFUVSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642AbXFUVSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbXFUVSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:18:21 -0400
Received: from gate.in-addr.de ([212.8.193.158]:48731 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755082AbXFUVSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:18:20 -0400
Date: Thu, 21 Jun 2007 23:17:43 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070621211743.GN20105@marowsky-bree.de>
References: <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-06-21T16:59:54, Stephen Smalley <sds@tycho.nsa.gov> wrote:

> Or can access the data under a different path to which their profile
> does give them access, whether in its final destination or in some
> temporary file processed along the way.

Well, yes. That is intentional.

Your point is?

> The emphasis on never modifying applications for security in AA likewise
> has an adverse impact here, as you will ultimately have to deal with
> application mediation of access to their own objects and operations not
> directly visible to the kernel (as we have already done in SELinux for
> D-BUS and others and are doing for X).  Otherwise, your "protection" of
> desktop applications is easily subverted.

That is an interesting argument, but not what we're discussing here.
We're arguing filesystem access mediation.

> Um, no.  It might not be able to directly open files via that path, but
> showing that it can never read or write your mail is a rather different
> matter.

Yes. Your use case is different than mine.



Regards,
    Lars

-- 
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde


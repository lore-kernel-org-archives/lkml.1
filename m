Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbYG1UMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbYG1UMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYG1UMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:12:34 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:62756 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbYG1UMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:12:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=UK68bVWe74f7zER6LPHyPOFkpAmr4rTbJHSZb0Fhi9tPCSILHX6Y3sas2M+g+JcPmg
         0bnRZdzfvhdf/MvvGyGt+Ru0Nx+BDNzwIBr/glvs0VAMF2qczoXqu4ozHqhSdZY4CtLE
         JK8KiTey4BDml2gbGNV3Iw09kOOOtZBtnWi0A=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling through rfkill
Date: Mon, 28 Jul 2008 22:32:37 +0200
User-Agent: KMail/1.9.9
Cc: Dan Williams <dcbw@redhat.com>, Philip Langdale <philipl@overt.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, toshiba_acpi@memebeam.org,
       linux-wireless@vger.kernel.org
References: <488CBBAB.6010508@overt.org> <1217243863.24609.6.camel@localhost.localdomain> <20080728185233.GB26564@khazad-dum.debian.net>
In-Reply-To: <20080728185233.GB26564@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807282232.38076.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008, Henrique de Moraes Holschuh wrote:
> On Mon, 28 Jul 2008, Dan Williams wrote:
> > On Mon, 2008-07-28 at 00:04 -0300, Henrique de Moraes Holschuh wrote:
> > > On Sun, 27 Jul 2008, Philip Langdale wrote:
> > > > Ivo van Doorn wrote:
> > > >> You don't seem to be using rfkill_force_state() which is required to inform the rfkill
> > > >> layer about the state changes.
> > > >
> > > > Hmm? According to rfkill.txt, one can either use force_state() or implement the
> > > > get_state() hook, and I have done the later. If this is not the correct method,
> > > > can you please explain when I should be using force_state?
> > > 
> > > There is a bunch of rfkill bug fix patches that was not merged in
> > > wireless-testing yet (which is a pity, it would be really good if they could
> > > go into 2.6.27).  One of those patches fixes the docs to make it clear that
> > 
> > Lots of wireless people (including John) were at OLS this past week, so
> > it's not entirely surprising that patch merging might have been slow.
> 
> That would explain it, yes...  Well, I sure hope this means the patches
> still have a non-zero chance of being sent to mainline for 2.6.27 :-)  I am
> not up to date on how merges are usually handled in the wireless and net
> subsystems.

The feature window for 2.6.27 closed with the release of 2.6.26, after that
only bugfixes can go in.

Ivo

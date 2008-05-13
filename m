Return-Path: <linux-kernel-owner+w=401wt.eu-S1758520AbYEMMXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbYEMMXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbYEMMXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:23:38 -0400
Received: from gate1.informatik.fh-wiesbaden.de ([195.72.96.254]:45460 "EHLO
	gate1.informatik.fh-wiesbaden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754987AbYEMMXh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:23:37 -0400
X-Greylist: delayed 3029 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2008 08:23:37 EDT
From: "Robert Kaiser (FH)" <kaiser@informatik.fh-wiesbaden.de>
Organization: Sysgo AG
To: xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] Re: [PATCH] xen: remove support for non-PAE 32-bit
Date: Tue, 13 May 2008 13:32:12 +0200
User-Agent: KMail/1.7.2
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <48243015.2010801@goop.org> <20080513110822.GA1679@elte.hu>
In-Reply-To: <20080513110822.GA1679@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805131332.14631.kaiser@informatik.fh-wiesbaden.de>
X-FHW-FB06-MailScanner: Found to be clean
X-FHW-FB06-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.502,
	required 5.5, ALL_TRUSTED -2.82, COMBINED_FROM 0.32)
X-MailScanner-From: kaiser@informatik.fh-wiesbaden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Dienstag 13 Mai 2008 13:08 schrieb Ingo Molnar:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > Non-PAE operation has been deprecated in Xen for a while, and is
> > rarely tested or used.  xen-unstable has now officially dropped
> > non-PAE support.  Since Xen/pvops' non-PAE support has also been
> > broken for a while, we may as well completely drop it altogether.
>
> applied, thanks.

Hmm, I had to revert to non-PAE operation (using xen 3.2.1) recently in order 
to get Xen to run under qemu. Does anyone know of another work-around to run 
Xen/Linux under qemu?

Rob

-- 
Robert Kaiser                    http://wwwvs.informatik.fh-wiesbaden.de
Labor für Verteilte Systeme            kaiser@informatik.fh-wiesbaden.de
FH Wiesbaden - University of Applied Sciences     tel: (+49)611-9495-294
Kurt-Schumacher-Ring 18, 65197 Wiesbaden, Germany fax: (+49)611-9495-294

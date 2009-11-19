Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZKSG4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZKSG4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 01:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZKSG4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 01:56:43 -0500
Received: from ozlabs.org ([203.10.76.45]:37415 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbZKSG4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 01:56:42 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: linux-next: manual merge of the edac-amd tree with the rr tree
Date: Thu, 19 Nov 2009 17:26:44 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Borislav Petkov <borislav.petkov@amd.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091119162354.8800a885.sfr@canb.auug.org.au> <20091119060648.GA15404@liondog.tnic>
In-Reply-To: <20091119060648.GA15404@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911191726.44667.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009 04:36:48 pm Borislav Petkov wrote:
> Hi Stephen,
> 
> On Thu, Nov 19, 2009 at 04:23:54PM +1100, Stephen Rothwell wrote:
> > Today's linux-next merge of the edac-amd tree got a conflict in
> > drivers/edac/amd64_edac.c because commit
> > 4de1ce0c99ff838090d3b57cab8bc6eeb303dda5
> > ("cpumask:amd64_edac-cpumask_t-remove") from the rr tree and commit
> > 2fd9af91b92c10e58993f9eb70300fdff32698fb ("cpumask: use modern cpumask
> > style in drivers/edac/amd64_edac.c") from the edac-amd tree are the same
> > patch but there are further changes in the edac-amd tree.  So, Rusty, I
> > guess you can drop that patch (unless something later in the rr tree
> > depends on it).
> 
> yes, we agreed I should pick up this patch. Rusty?

Thanks!

Rusty.

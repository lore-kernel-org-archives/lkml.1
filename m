Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbYADPCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbYADPCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 10:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYADPCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 10:02:39 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:60383 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYADPCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:02:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CSDFK6HCjfdg7x/S3fyJRp4lkuLRemzFrizFdu+ufJIv/T2u1mEW+Pg9L3LfFedrbVt/2pVI+Nb/BjI/9wK0MNpDzi1H+814IFAUXAa0z0qtIdc/hFGA+JKrhfpmgGJ8tY8HzdeLDn1ba1cQeetrs2tH092swYqxso6QbD2Gs0k=
Message-ID: <84144f020801040702x23469d69n8e3643221d38dfb0@mail.gmail.com>
Date: Fri, 4 Jan 2008 17:02:37 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH x86] [12/16] Optimize lock prefix switching to run less frequently
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200801041539.27370.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080103442.621670000@suse.de> <200801041317.30404.ak@suse.de>
	 <alpine.LFD.0.99999.0801041449460.4042@localhost.localdomain>
	 <200801041539.27370.ak@suse.de>
X-Google-Sender-Auth: 5d16db3c565a77e1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Jan 4, 2008 4:39 PM, Andi Kleen <ak@suse.de> wrote:
> > The kernel process request that _all_ contributors run their patches
> > through checkpath.pl and fix the problems.
>
> That's new. When and by whom was that rule been introduced? And with what
> rationale?

Not be new to anyone trying to sneak a patch past Andrew for the past
few months...

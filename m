Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbYCNA0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbYCNA0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYCNA0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:26:30 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:35481 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbYCNA03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:26:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NprANraEfTMYcLrdeTAI585Om1gx0/0N6Vy/+EgKXQ5nSxw3wBC1il8dx7Qu6coa154ei189PdKJc+j2U6hTCn8eT/s/nb/aMi/nPM/shDa7gN9xEgEaDI8R6yoG8QKCiCRAtRSRCVxmfn9d31+EpnJlqgTqMRu9IaoyFsJtBUE=
Message-ID: <9810cff90803131726m55e11b62o5cdebd078626283f@mail.gmail.com>
Date: Thu, 13 Mar 2008 17:26:26 -0700
From: "Bill Huey (hui)" <bill.huey@gmail.com>
To: "Gregory Haskins" <ghaskins@novell.com>, mingo@elte.hu
Subject: Re: [PATCH RT 0/6] lockstat measurement extensions
Cc: a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       kevin@hilman.org, cminyard@mvista.com, dsingleton@mvista.com,
       dwalker@mvista.com, npiggin@suse.de, dsaxena@plexity.net, ak@suse.de,
       pavel@ucw.cz, acme@redhat.com, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
In-Reply-To: <9810cff90803131703t3626d83fq727b04242f407c13@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9810cff90803131703t3626d83fq727b04242f407c13@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, this is not meant for inclusion in it's current revision. It'll
need to have various compilation modes
(CONFIG_PREEMPT_RT/CONFIG_LOCK_STAT) combination enabled and such. I'm
handing this over to Peter Morreale and it'll be up to him to decided
what to do next.

However, it does work and should get interesting numbers for the
discussion of whether or not adaptive spins and friends are useful or
not.

bill

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763531AbYASBZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763531AbYASBZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbYASBYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:24:54 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:25254 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbYASBYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:24:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AfuLRnLCZVaYQiCNOYY7BAkgfDqmZE4O5tcZh5s8X1bJzZyR17SqdtJB9TPsHnMP84gZ/+CHkbSqyWvlNh5HVCO0bKEPqRk75fnKc5Ud6j3BAP5IG6DO9Sh89Sf2tfO8IwajzbM9BDN1FxFJkgp3ViQyXa1Z0ap4MNEvVadVmu8=
Message-ID: <5d6222a80801181724p40bdedebgded1d43b052d168e@mail.gmail.com>
Date: Fri, 18 Jan 2008 23:24:51 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/10] Tree fixes for PARAVIRT
Cc: "Zachary Amsden" <zach@vmware.com>,
       "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       roland@redhat.com, mtosatti@redhat.com
In-Reply-To: <20080118220200.GA1071@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12006768251548-git-send-email-gcosta@redhat.com>
	 <20080118203259.GA3079@elte.hu> <20080118213711.GA24979@elte.hu>
	 <1200693248.21817.157.camel@bodhitayantram.eng.vmware.com>
	 <20080118220200.GA1071@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 8:02 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Zachary Amsden <zach@vmware.com> wrote:
>
> > > but in exchange you broke all of 32-bit with CONFIG_PARAVIRT=y.
> > > Which means you did not even build-test it on 32-bit, let alone boot
> > > test it...
> >
> > Why are we rushing so much to do 64-bit paravirt that we are breaking
> > working configurations?  If the developement is going to be this
> > chaotic, it should be done and tested out of tree until it can
> > stabilize.
>
> what you see is a open feedback cycle conducted on lkml. People send
> patches for arch/x86, and we tell them if it breaks something. The bug
> was found before i pushed out the x86.git devel tree (and the fix is
> below - but this shouldnt matter to you because the bug never hit a
> public x86.git tree).
>
>         Ingo
>
Other than this, it seems to build and boot fine.

Do you want me to resend ?
-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."

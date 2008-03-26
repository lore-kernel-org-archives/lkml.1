Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbYCZFIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbYCZFIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 01:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYCZFIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 01:08:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53529 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbYCZFIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 01:08:06 -0400
Subject: Re: Fixing the main programmer thinko with the device model
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Van De Ven, Arjan" <arjan@linux.intel.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080326041631.GB28224@kroah.com>
References: <1206373188.3494.36.camel@localhost.localdomain>
	 <20080324175844.GA13816@kroah.com>
	 <1206382109.3494.69.camel@localhost.localdomain>
	 <87ve3bi0s3.fsf@basil.nowhere.org>  <20080326041631.GB28224@kroah.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 26 Mar 2008 06:07:49 +0100
Message-Id: <1206508069.24783.16.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1+xMcUkHZ4lFac3bGS4O25LiLEOwk2OgLc38rk
 MQ50EK5RVwGrGmx62fG5I4dBumeSnSxFJHFMxGEK6C4UMwb/Uj
 e4XwF5AEq/aiqpf55s83uPVb4Vw7pw7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-25 at 21:16 -0700, Greg KH wrote:
> On Tue, Mar 25, 2008 at 10:57:32AM +0100, Andi Kleen wrote:
> > James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> > > 
> > > That's true, but irrelevant (and also soon to be untrue if we get rid of
> > > the scsi_device class as you and Kay keep requesting).  The two calls
> > > release references on the actual embedded generic device, it's nothing
> > > to do with entangled lifetime rules.
> > 
> > <heretic thought>Has anybody ever considered just doing away with 
> > the problematic and bug prone and tricky reference counts for kobjects 
> > and switch to a simple garbage collector for them?
> 
> Sure, I have no objection to that.  It's just that the reference count
> "issue" really doesn't seem to be one on sanely designed busses :)

Hmm, what is a "﻿simple garbage collector" here? How could one determine
"reachability" of objects, means: at what point of time do objects
actually become "garbage"? How could one trace in our current kernel
code who still accesses an object, without doing refcounts?

Kay


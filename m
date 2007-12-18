Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbXLRVc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbXLRVc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbXLRVct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:32:49 -0500
Received: from hpsmtp-eml15.KPNXCHANGE.COM ([213.75.38.115]:55755 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbXLRVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:32:48 -0500
From: Frans Pop <elendil@planet.nl>
To: "Glauber de Oliveira Costa" <glommer@gmail.com>
Subject: Re: [PATCH] finish processor.h integration
Date: Tue, 18 Dec 2007 22:32:43 +0100
User-Agent: KMail/1.9.7
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>, ak@suse.de,
       akpm@linux-foundation.org, anthony@codemonkey.ws, avi@qumranet.com,
       chrisw@sous-sol.org, ehabkost@redhat.com, hpa@zytor.com,
       jeremy@goop.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       roland@redhat.com, rostedt@goodmis.org, rusty@rustcorp.com.au,
       tglx@linutronix.de, virtualization@lists.linux-foundation.org,
       zach@vmware.com
References: <1198008293639-git-send-email-gcosta@redhat.com> <E1J4jSf-00024X-GN@faramir.fjphome.nl> <5d6222a80712181300l707035e7mdb8a6e0d7a5ddca8@mail.gmail.com>
In-Reply-To: <5d6222a80712181300l707035e7mdb8a6e0d7a5ddca8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712182232.45685.elendil@planet.nl>
X-OriginalArrivalTime: 18 Dec 2007 21:32:46.0143 (UTC) FILETIME=[87B464F0:01C841BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 December 2007, Glauber de Oliveira Costa wrote:
> On Dec 18, 2007 6:54 PM, Frans Pop <elendil@planet.nl> wrote:
> > Glauber de Oliveira Costa wrote:
> > > What's left in processor_32.h and processor_64.h cannot be cleanly
> > > integrated. However, it's just a couple of definitions. They are
> > > moved to processor.h around ifdefs, and the original files are
> > > deleted. Note that there's much less headers included in the final
> > > version.
> >
> > Either I must be missing something or this patch was corrupted somehow.
>
> neither.
> Note the else in the middle. It's just a mistake in the comment.

Wouldn't an explicit second #ifdef block be a lot clearer (and improve 
maintainability) in this case?

An #else can easily be overlooked among other preprocessor commands or when 
#ifdefs get nested.

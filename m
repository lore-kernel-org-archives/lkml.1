Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbXHHL7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbXHHL7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 07:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbXHHL7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 07:59:08 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:58831 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbXHHL7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 07:59:06 -0400
Date: Wed, 8 Aug 2007 07:58:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <ak@suse.de>
cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
In-Reply-To: <200708081200.13669.ak@suse.de>
Message-ID: <Pine.LNX.4.58.0708080754230.5921@gandalf.stny.rr.com>
References: <11865467522495-git-send-email-gcosta@redhat.com>
 <1186546847263-git-send-email-gcosta@redhat.com> <11865468513077-git-send-email-gcosta@redhat.com>
 <200708081200.13669.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 8 Aug 2007, Andi Kleen wrote:

> Strictly you would at least need a !X86_VSMP dependency, but
> with the vsmp change i requested that will be unnecessary
>
> Is this really synced with the latest version of the i386 code?

Glauber started the paravirt ops 64 a second time around, from scratch
using the PVOPS of i386 as a base. But since we couldn't just take a the
PVOPS patch from i386 and apply it to x86_64, this was mainly done by
looking at i386 code and massaging it for x86_64. Somethings may have
slipped (and we may have been looking at different versions of PVOPS).
It's not easy trying to keep up with a moving target ;-)

-- Steve


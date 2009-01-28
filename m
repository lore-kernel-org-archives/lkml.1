Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZA1WZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZA1WZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbZA1WZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:25:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58226 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbZA1WZj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:25:39 -0500
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH RFT 7/7] firewire: sbp2: add workarounds for 2nd and 3rd generation iPods
Date: Wed, 28 Jan 2009 17:25:25 -0500
User-Agent: KMail/1.10.4 (Linux/2.6.27.12-170.2.5.fc10.x86_64; KDE/4.1.4; x86_64; ; )
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian =?iso-8859-1?q?H=F8gsberg?= <krh@bitplanet.net>,
       linux-kernel@vger.kernel.org
References: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de> <tkrat.b82b9fbc17b1a032@s5r6.in-berlin.de> <200901281718.41873.jarod@redhat.com>
In-Reply-To: <200901281718.41873.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901281725.25750.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2009 17:18:41 Jarod Wilson wrote:
> >   - Is the "no page tables" workaround really necessary for 2nd gen.
> >     iPods, or is the 128k limit sufficient as reported for the Ubuntu
> >     8.10 kernel?
>
> Looks to me like the no page tables workaround isn't needed. I could
> have sworn the defaults w/this patch (workarounds 0x48) was actually
> causing dd to fail last night, but I haven't been able to reproduce
> that failure, now that I'm trying (maybe I this ipod mixed up with one
> of the others in the pile...).

Yep, I'm a dummy. The failure I was thinking of was w/the completely
flaky 3rd-gen iPod, just went back and looked at logs.

So far as I can tell, I'm thinking 128k limit + fix capacity should be
okay for both the 2nd and 3rd-gen iPods, and if someone comes up with
evidence that the 2nd-gen does something badly w/the fix capacity
workaround enabled, then we revisit trying to apply the workarounds
more narrowly somehow.

-- 
Jarod Wilson
jarod@redhat.com


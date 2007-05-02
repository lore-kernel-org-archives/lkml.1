Return-Path: <linux-kernel-owner+w=401wt.eu-S1767156AbXEBXDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767156AbXEBXDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 19:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767138AbXEBXDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 19:03:48 -0400
Received: from gw.goop.org ([64.81.55.164]:54389 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767156AbXEBXDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 19:03:46 -0400
Message-ID: <463918CF.4000202@goop.org>
Date: Wed, 02 May 2007 16:03:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Gerd Hoffmann <kraxel@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeff Garzik <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	<20070428175909.1D09D151CA@wotan.suse.de>	<46338D72.70402@garzik.org>	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com>	<4634483E.9030307@goop.org>	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org> <46385A8A.6070405@redhat.com> <4638AB55.20408@goop.org> <4638F9BE.8090508@zytor.com> <4638FC39.4010101@goop.org> <4638FE1B.9050901@zytor.com> <46390523.5010809@goop.org> <463909AF.9040205@zytor.com>
In-Reply-To: <463909AF.9040205@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> I don't know if that would break any programs that are currently
> bypassing the setup.  The existing setup protocol definitely allows
> invoking an entry point which isn't 0x100000 (rather, the 32-bit
> entrypoint is defined by code32_start); I'm not sure how Eric's
> relocatable kernel patches (2.05 protocol) affect that, mostly because I
> haven't seen any boot loaders which actually use it so I can't comment
> on what their code looks like.

Yes, I'd expect that code32_start would point into the ELF text
segment.   You could align things so that the entrypoint is still
actually 0x100000, or bump it up a bit to fit the ELF headers.  I have
to admit I don't quite understand how all that fits together at the moment.

    J


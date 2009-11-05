Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbZKEQ22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbZKEQ22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 11:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbZKEQ21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 11:28:27 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:50935 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752830AbZKEQ20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:28:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=X55kIvqqcp2kqZ34Ld5p48RMfNJN+LM1gzXNR6E+1WUpXfmwmRwngoWEGUZglkETdoqubZnK2eP18tonKzg5f2zAc6UATYQfpCOa1CXDaDzN6z6rlaQR0VsxSx+3MN4p;
Date: Thu, 5 Nov 2009 08:28:29 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [resend] i915: high power consumption after suspend/resume
Message-ID: <20091105082829.2d59dcae@jbarnes-piketon>
In-Reply-To: <cb0375e10911042000h3cf215a1o44add74510c15a1c@mail.gmail.com>
References: <cb0375e10910030939v8d03df7m861a2f05219f173c@mail.gmail.com>
	<cb0375e10910030950kcd19fe9i7835eaaf4314c0fb@mail.gmail.com>
	<20091005092148.4341d9ab@jbarnes-g45>
	<cb0375e10910072044m470c8cbasef33de3b36bb62ee@mail.gmail.com>
	<20091029094723.7e5a3376@jbarnes-g45>
	<cb0375e10910291022l5650994dyc4a36d55f1e5bbc4@mail.gmail.com>
	<cb0375e10910291040i31a7b9aatb6da5c20778d9791@mail.gmail.com>
	<cb0375e10910292325l659034c4u36cf263cda8e90c8@mail.gmail.com>
	<20091030083742.48f5d4f3@jbarnes-g45>
	<cb0375e10910301155s5e2b2e79t562bfa798ba75e23@mail.gmail.com>
	<cb0375e10911042000h3cf215a1o44add74510c15a1c@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009 23:00:14 -0500
Andrew Lutomirski <luto@mit.edu> wrote:
> so it looks like it's not a register setting after all.  Maybe my BIOS
> leaves the renderer in some weird state.

Note that the register dumping tool doesn't capture everything.  If you
really want to do some detective work you could dump the whole MMIO
space and compare differences.  You should be able to find definitions
for many of the reg offsets in the docs at intellinuxgraphics.org,
maybe there's something we don't dump that's changing and that explains
your power consumption changes.

-- 
Jesse Barnes, Intel Open Source Technology Center

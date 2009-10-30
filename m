Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbZJ3Pho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbZJ3Pho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 11:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756397AbZJ3Pho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 11:37:44 -0400
Received: from outbound-mail-11.bluehost.com ([69.89.18.111]:35761 "HELO
	outbound-mail-11.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752619AbZJ3Phn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 11:37:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NWIFZrJVHes42O8FnIhWFW3zfWzK7xIc5xvpBhhL9WDqmMR3BRm25EHhdipA5slaHSsJfet87+avalEXmRWd3jVlx35I8B4eW83wS8wDjtshROkQRfbZ6ZHhivnd+4xK;
Date: Fri, 30 Oct 2009 08:37:42 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [resend] i915: high power consumption after suspend/resume
Message-ID: <20091030083742.48f5d4f3@jbarnes-g45>
In-Reply-To: <cb0375e10910292325l659034c4u36cf263cda8e90c8@mail.gmail.com>
References: <cb0375e10910030939v8d03df7m861a2f05219f173c@mail.gmail.com>
	<cb0375e10910030950kcd19fe9i7835eaaf4314c0fb@mail.gmail.com>
	<20091005092148.4341d9ab@jbarnes-g45>
	<cb0375e10910072044m470c8cbasef33de3b36bb62ee@mail.gmail.com>
	<20091029094723.7e5a3376@jbarnes-g45>
	<cb0375e10910291022l5650994dyc4a36d55f1e5bbc4@mail.gmail.com>
	<cb0375e10910291040i31a7b9aatb6da5c20778d9791@mail.gmail.com>
	<cb0375e10910292325l659034c4u36cf263cda8e90c8@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009 02:25:21 -0400
Andrew Lutomirski <luto@mit.edu> wrote:

> On Thu, Oct 29, 2009 at 1:40 PM, Andrew Lutomirski <luto@mit.edu>
> wrote:
> >
> > I just suspended and resumed and power consumption stayed low.  I'll
> > try and get an intel_reg_dumper diff next time I trigger this bug.
> 
> intel_reg_dumper blames RENCLK_GATE_D2.  Patch coming.
> 
> Maybe my BIOS doesn't always reset it.

Does resetting that reg get your power savings back?

-- 
Jesse Barnes, Intel Open Source Technology Center

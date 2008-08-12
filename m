Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYHLU5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYHLU5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYHLU5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:57:34 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58081 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbYHLU5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:57:32 -0400
In-Reply-To: <20080812193031.GD18034@infradead.org>
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Mimi Zohar <zohar@us.ibm.com>
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF6C940C00.249617D7-ON852574A3.0071F8B0-852574A3.00732160@us.ibm.com>
From: Kenneth Goldman <kgoldman@us.ibm.com>
Date: Tue, 12 Aug 2008 16:57:31 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V85_M1_05262008|May 26, 2008) at
 08/12/2008 16:57:31
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote on 08/12/2008 03:30:31 PM:

> On Mon, Aug 11, 2008 at 05:13:51PM -0400, Mimi Zohar wrote:
> >
> > I assume the concern here is that between looking up the chip and
actually
> >
> > using the chip, the TPM chip is disabled/deactivated.  Based on
> > discussions
> > with Kenneth Goldman, the TCG main specification part2: structures,
> > require
> > that even if the TPM is disabled/deactivated, the command to extend the

> > PCR
> > will succeed, but the command to read the PCR will fail with an
> > appropriate
> > error code.
>
> And what happens when the chip simply goes away due to a hotplug action?
> Or not even the actual chip goes away but just the chip driver and you
> now dereference freed memory?

Being a TCG/TPM person, I can only address the first question.  The
intent is that the TPM is soldered to the planar/motherboard (the TCG
uses the phrase "bound to the platform").  I can't imagine
any manufacturer designing a pluggable TPM.  It would subvert PCR
measurements and thus attestation, data sealing, etc.


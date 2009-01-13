Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZAMAs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZAMAs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 19:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZAMAsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 19:48:18 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41673 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130AbZAMAsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 19:48:17 -0500
Subject: Re: ACPI hotplug panic with current git head
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901121604380.5859@localhost.localdomain>
References: <1231604250.3642.33.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0901121604380.5859@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 18:48:13 -0600
Message-Id: <1231807693.27151.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 16:16 -0500, Len Brown wrote:
> > This is on an IBM Maia system with the calgary IOMMU enabled. It's a
> > fatal boot up panic.
> > 
> 
> James,
> A guided bisect...
> Please let me know which of these fail
> 
> a3a798c88a14b35e5d4ca30716dbc9eb9a1ddfe2 is 2.6.29 at ACPI merge
> efcb3cf7f00c3c424db012380a8a974c2676a3c8 is 2.6.29 before ACPI merge

Didn't try these (being after the failure)

> ec9f168fcc344d2ffec1c8c822076bf22dab5c33 is 2.6.28 with most ACPI

This is the failing one.

> e8443c358c34f3fe65236e24147ddf0cd0e61b08 is 2.6.28 plus just ACPICA

This one boots fine.

> Please test the "2.6.28+ACPICA" one first.
> If it fails, we are close so you can skip the others above
> and bisect between that and 2.6.28.

I'll try bisecting between ec9f168fcc344d2ffec1c8c822076bf22dab5c33 and
e8443c358c34f3fe65236e24147ddf0cd0e61b08.

James



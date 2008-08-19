Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbYHSTDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbYHSTDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758002AbYHSTDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:03:04 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:63296 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998AbYHSTDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lQpSPb6fvsSg3DFvaysuAqwoNjl64oPR4VQCp0vofv9yLDXpBjwyNZ1n0vNtWHFVig
         hAJcvk8Y3yoQDEHR9zCzAhSfH3Aig9SCniTlxjTUbE/5ounZDFaHGeAzI7GWRN/8iti1
         mRdiw4wwMD4rjNcAYx1InTEy0NG3hkM51f9cg=
Subject: Re: [PATCH 02/23] arm: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080819072715.GB30521@flint.arm.linux.org.uk>
References: <1219106875.17033.55.camel@brick>
	 <20080819072715.GB30521@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 12:03:00 -0700
Message-Id: <1219172580.17033.87.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-19 at 08:27 +0100, Russell King wrote:
> On Mon, Aug 18, 2008 at 05:47:55PM -0700, Harvey Harrison wrote:
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> >  arch/arm/include/asm/byteorder.h |   25 +++++++++++--------------
> >  1 files changed, 11 insertions(+), 14 deletions(-)
> 
> You keep posting this, and it's the only bit I see, but... what about
> the other bits that it depends on, which without them, it's impossible
> to test this patch with?
> 

include/linux/swab.h, include/linux/byteorder.h are in current mainline
which is all that these patches depend on.

Harvey


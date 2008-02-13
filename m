Return-Path: <linux-kernel-owner+w=401wt.eu-S933028AbYBMTJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028AbYBMTJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbYBMTJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:09:09 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54586 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753268AbYBMTJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:09:08 -0500
Subject: Re: [PATCH] Adaptec AACRAID: convert fibctx->wait_sem to completion
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: aacraid@adaptec.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080213183444.GA27068@traven>
References: <20080213183444.GA27068@traven>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 13:09:00 -0600
Message-Id: <1202929740.3109.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-13 at 19:34 +0100, Matthias Kaehlcke wrote:
> Adaptec AACRAID driver: The semaphore fibctx->wait_sem is used for
> signalling an event. Convert it to a completion.

What's the purpose of doing this?  The aacraid implementation seems to
be a classic PV semaphore, so why does it need to become a completion?

James



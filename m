Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbYHCXIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbYHCXIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 19:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758865AbYHCXHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 19:07:50 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42370 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758236AbYHCXHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 19:07:49 -0400
Subject: RE: [PATCH 2/2] fusion:  Implement generic interrupt misroute
	handling
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "Prakash, Sathya" <Sathya.Prakash@lsi.com>
In-Reply-To: <660360F4F2570145BD872F298951B17A3ADCEDB9@cosmail03.lsi.com>
References: <1217786709.4179.27.camel@localhost.localdomain>
	 <660360F4F2570145BD872F298951B17A3ADCEDB9@cosmail03.lsi.com>
Content-Type: text/plain
Date: Sun, 03 Aug 2008 18:07:44 -0500
Message-Id: <1217804865.4179.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-03 at 16:59 -0600, Moore, Eric wrote:
> Thanks, I will try this out.   However I thought I saw lost interrupts
> occurring randomly, meaning it was not necessarily the first config
> page access.  I'm back in the office on 8/11, I will test it out then
> and provide feedback.

Well, this is the usual trouble.  I don't have a misbehaving
motherboard, so I artificially induce MSI problems on my platform.  For
me, it works, but obviously I'm losing every MSI interrupt.

James



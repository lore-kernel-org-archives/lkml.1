Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbZAKVOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbZAKVOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZAKVOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:14:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:55214 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbZAKVOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:14:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JyOFo/gc6UAr27M/TR7cxhD3dGAiGabgZ1iqEGtp0GXxQbb0gdwnfFlMeeIO6oYqU0
         GRRnrSDmdYGf0Apzd5tQTBcDbeh2XOV460DbDlx/LbuIYedDRG8Q+u5rdldv3Z5lu9gT
         OdT3nVT4l7Nb8Z8rJosCteUvQ/rmpl0lifZLc=
Subject: Re: [Bug #12399] USB wakeup problem on Toshiba Portege R500
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <oWTznAnH9BI.A.9V.bHfaJB@chimera>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
	 <oWTznAnH9BI.A.9V.bHfaJB@chimera>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 23:14:07 +0200
Message-Id: <1231708447.22672.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-11 at 12:12 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12399
> Subject		: USB wakeup problem on Toshiba Portege R500
> Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
> Date		: 2009-01-08 7:35 (4 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6fd9086a518d4f14213a32fe6c9ac17fabebbc1e
> References	: http://marc.info/?l=linux-kernel&m=123140019117968&w=4
> 

Happens here on aspire 5720G, and yes unloading ehci_hcd makes
suspend/resume work, otherwise system resumes immediately.

best regards,
	Maxim Levitsky


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751397Ab0AKGFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab0AKGFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 01:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324Ab0AKGFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 01:05:49 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:54776 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0AKGFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 01:05:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=vZDMdSfGettEa9ssquw1B5Xil4YhXDjYsajvXqHb7sDrL8hxsK5h0V/i02AbIKG7PN
         82mXTxqVZSyAeBFYsc3Woc3HAODMx31SjkCb9fxOrGYr7PHF2rjWkhtbf3Pwwyvh854H
         zBdArgnvvJEvEj8OIiscxboPLlAXxU7zSin8o=
Date: Mon, 11 Jan 2010 07:05:41 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14948] EHCI resume sysfs duplicates
Message-ID: <20100111060541.GA19865@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
 <omZ8aBZReyD.A.1WH.ONlSLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <omZ8aBZReyD.A.1WH.ONlSLB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 11:32:55PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14948
> Subject		: EHCI resume sysfs duplicates
> Submitter	: Borislav Petkov <petkovbb@googlemail.com>
> Date		: 2009-12-26 9:36 (16 days old)
> References	: http://marc.info/?l=linux-kernel&m=126182020615709&w=4

Preliminary and tested fix is at LKML-Reference: <20100105220829.GA31569@xanatos>

-- 
Regards/Gruss,
    Boris.

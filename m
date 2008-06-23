Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbYFWSaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbYFWSaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758541AbYFWSaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:30:23 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:26078 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbYFWSaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:30:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fv8+UTDLR/4A2R9K7K9LOosJ9Zw8Iafn2QF8IuwHVzuohT4YZrlp/SDiknZv9wEpUC
         WHH2MwcyjM1kDgkVit4m7jsgIAkam8ioBVWTWIAfDHE7m94+RuE6Mi7DXseoI4aChxo/
         Yo3OT+62OmbFsyDUHmTEdjXGxUC9PCpXrr4Fo=
Message-ID: <ebd55800806231130l406f5490sc7c19f202ef81f8b@mail.gmail.com>
Date: Mon, 23 Jun 2008 14:30:20 -0400
From: Ian <isoboroff@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Oops in NFS (RHEL4, but also in kernel bugzilla)
In-Reply-To: <ebd55800806231129k110febb6rc2edfc18a7af5588@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806181933l74719bdbkea02f697ee424157@mail.gmail.com>
	 <9cfod5sayiq.fsf@rogue.ncsl.nist.gov>
	 <6278d2220806231117v551d93f1o7ecb5c7558a62b96@mail.gmail.com>
	 <ebd55800806231129k110febb6rc2edfc18a7af5588@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 2:17 PM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:

> There is chance that you've overrun the 4KB stack. Can you retest with
> CONFIG_4KSTACK disabled perhaps?

Testing is hard as the oops is not easily reproducible, but I'll
prepare a non-4KSTACKS kernel so that I can boot to it if we oops
again.

I'm still interested to hear from someone if the patch in bugzilla is
good for catching a real error case, or if it's papering over a larger
problem (for example a stack overrun).

Ian

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZDDMfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZDDMfk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 08:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbZDDMfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 08:35:30 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:45413 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbZDDMfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 08:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=mwkkOvzXUc8739oc1noaf6U7FhEBZVqpLfI2J72QnEBiToioCjYZBexAKVsq5By5y+
         /xKk5b6BDTgDMH2TTfvc4V82afsOqDQ5ZGP+TzHw7WT+t/emlyzRjwXiDn19guovTKR0
         jXxEep8mHedJCdeyDzzIlMy3WYJMap3G04g7c=
MIME-Version: 1.0
In-Reply-To: <504C2315A8%linux@youmustbejoking.demon.co.uk>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk>
	 <20090404041813.GA30746@srcf.ucam.org>
	 <71cd59b00904040133p1f130673r4e93d2c48f8f4616@mail.gmail.com>
	 <504C2315A8%linux@youmustbejoking.demon.co.uk>
Date: Sat, 4 Apr 2009 14:35:26 +0200
Message-ID: <71cd59b00904040535t51f0e8bew34b487e0a3703f7e@mail.gmail.com>
Subject: Re: [PATCH 2.6.29] eeepc-laptop: report brightness control events via 
	the input layer
From: Corentin Chary <corentin.chary@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> How can brn be -2?
> If notify_brn() wasn't called, it will be.
Oh, yeah, I miss the if() before notify_brn()

>> And why -2?
> Because notify_brn() won't return it (and if it ever does, it needs to be
> fixed). (Yes, I know, "magic numbers" and all that...)
Maybe a negative known error code could be used here


-- 
Corentin Chary
http://xf.iksaif.net

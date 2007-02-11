Return-Path: <linux-kernel-owner+w=401wt.eu-S1749667AbXBKPTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1749667AbXBKPTm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 10:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750695AbXBKPTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 10:19:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:39440 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXBKPTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 10:19:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=J0rt/jHrmlp4RLJgcwVS95ksq4pG4/3D6JA3Ne87vWpOh+TgiC6JTXvLpGU53KI9+S1tiTClRDsQgshz9D6VQKTc5JUi10SsYUPUo14aTnbjRIDfSw/Tevx695v5A5eouY9uPVyYr/rbLnkm5uFaLSOfKxwdRxcgheuGDvb24Lg=
Message-ID: <84144f020702110719i27718657s4c74a4f7217cce6@mail.gmail.com>
Date: Sun, 11 Feb 2007 17:19:40 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
Cc: "Willy Tarreau" <w@1wt.eu>, "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Daniel Barkalow" <barkalow@iabervon.org>, nigel@nigel.suspend2.net,
       "Robert Hancock" <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Pavel Machek" <pavel@ucw.cz>,
       "pm list" <linux-pm@lists.osdl.org>
In-Reply-To: <200702111536.20871.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
	 <200702111450.49736.rjw@sisk.pl> <20070211135708.GC1868@1wt.eu>
	 <200702111536.20871.rjw@sisk.pl>
X-Google-Sender-Auth: 192f3e786a08af57
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/11/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Unfortunately it has to be done in one shot for all of the known good drivers to avoid
> user-observable regressions.

No you don't. You can make it a config option that defaults to n
during a transition period.

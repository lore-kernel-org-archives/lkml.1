Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYABS7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYABS7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYABS73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:59:29 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:49583 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbYABS72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:59:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A/VHlG+xByBtVOOnHIBH3HYGgxURdiBlXj1JwQN96vCd4KucvpIX+Cy4UpyW6vnDqeAhwLELsyo4YpugASUP6FRTHTRAXyb6aPonXkaonaJmh8ni1vAsLgI9E6Dhr+/UhzQKkpXTua14LlDoDIxQO7OtFrSSBJzKOhKUqp5IKyE=
Message-ID: <8bd0f97a0801021058g15d32de7nd29102ec552ba5fa@mail.gmail.com>
Date: Wed, 2 Jan 2008 13:58:56 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB options normally reserved for OTG
Cc: linux-usb-devel@lists.sourceforge.net,
       "Robin Getz" <rgetz@blackfin.uclinux.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801021047.16036.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801020948.51310.rgetz@blackfin.uclinux.org>
	 <200801021047.16036.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 2, 2008 1:47 PM, David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 02 January 2008, Robin Getz wrote:
> > From: Robin Getz <rgetz@blackfin.uclinux.org>
> >
> > Allow embedded developers to turn support for USB Hubs off even if they have a
> > full root hub. This saves the overhead (RAM and Flash size).
>
> ISTR that it won't save very much code though ... the Linux USB
> stack structures all its enumeration logic around hubs.

perhaps the code size is arguable as to whether it really matters.
the reason we want it is that we have a USB host controller that will
not work with USB hubs, so we want to make sure the system does not
attempt such things.  (yes, such a USB host controller is retarded,
but the decision was out of our hands.)
-mike

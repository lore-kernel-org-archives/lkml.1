Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbXG1Qlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbXG1Qlb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXG1QlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:41:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:28360 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbXG1QlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:41:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=A3qX8yVVcr6pb12LDBcGLZ/FM3j4pjBNPYp+qY/2Iy9yPEKPI5BUK9suzff9a5JhIceB1lOfS2JyAAJzGJBF8BjIbDrG4yS2FjS/f7HjyLjRWS2HSYT0uMWsbPPbW8SDmLEHt7vak3pklbEGDU3/1DEU3z9xtFXrT5irLVNLiqQ=
Message-ID: <2c0942db0707280941n1b9e1f7i9c0de332286e8aac@mail.gmail.com>
Date: Sat, 28 Jul 2007 09:41:20 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Lee Howard" <faxguy@howardsilvan.com>
Subject: Re: serial flow control appears broken
Cc: "Paul Fulghum" <paulkf@microgate.com>, "Tilman Schmidt" <tilman@imap.cc>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <46AACB4D.7080004@howardsilvan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>
	 <46A84B4A.6070902@shaw.ca> <46A8C6F1.4080309@howardsilvan.com>
	 <20070726173121.70088a92@the-village.bc.nu>
	 <46A98845.8010806@howardsilvan.com> <46A9F712.70706@imap.cc>
	 <46D33636.7070200@microgate.com> <46AA5A0E.1050600@howardsilvan.com>
	 <1185578908.2989.15.camel@x2> <46AACB4D.7080004@howardsilvan.com>
X-Google-Sender-Auth: 8f8f7d119e3fe7d1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/27/07, Lee Howard <faxguy@howardsilvan.com> wrote:
> Curiously, the session at 38400 bps that skipped 858 bytes... coincided,
> not just in sequence but also in precice timing within the session, with
> a small but noticeable disk load that I caused by grepping through a
> hundred session logs.  (I can't reproduce it easily, though, because of
> disk caching.)

`echo 1 > /proc/sys/vm/drop_caches` will clear out most (all?) of what
the kernel has cached from the drive. It's there just for this kind of
repeatability of tests...

Ray

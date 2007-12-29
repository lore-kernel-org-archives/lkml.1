Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbXL2XEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbXL2XEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 18:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbXL2XET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 18:04:19 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:53932 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609AbXL2XER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 18:04:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C0taqKcArEqnGENFBb5wLRG3eMct32EC2JyMb33LEhbppw4WZsV2V7elyTrfYNr1VhHRc9Lxl3FahyPN8X6CZ2n5mFyGz+I3VOHQ8WZQw1uL+o5IJj7pLN/gTobnWFQI2WTbWJlYm8AJQahNxK2pV4mR2CZaFslCtuRkXNlf2t0=
Message-ID: <e85b9d30712291504r2f4ef991w33f501ccf0d41c2b@mail.gmail.com>
Date: Sun, 30 Dec 2007 00:04:17 +0100
From: Matthew <jackdachef@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
Cc: roland@redhat.com, "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de
In-Reply-To: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so I was wrong XD

sorry,

the error was found in the meantime:

see: http://forums.gentoo.org/viewtopic-p-4667858.html#4667858

Don't need to do more testing. The culprit is the unification of the
x86 i387 code.

The culprit is 57c3da2f5bb3fafedc31284117ae43bc593b65ab or
f10c1cfd359660c01446807b6c2bc8ce3aee919a

see http://forums.gentoo.org/viewtopic-p-4667906.html#4667906 and next post

Greetings

Mat

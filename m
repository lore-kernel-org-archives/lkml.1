Return-Path: <linux-kernel-owner+w=401wt.eu-S1751483AbXBMS0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbXBMS0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbXBMS0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:26:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:40781 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbXBMS0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:26:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Iw2d17fiqWysQJDCTpI82usm+7UCZRqiMLVpRm9EKkkPNcF4mfznUW8SZxiGiVmug2MIEipipjECyoid8+2duiZCVQnz0ET8xs6QdTGnoHLwZ3+df2BSMhpcwNbAj7/Lzcs02Rr4ZVpvjbp8RROPsxDwL8g/fnBpr7B3ifehgrY=
Message-ID: <84144f020702131026q2af1afd6vbcd2708d7b7b9907@mail.gmail.com>
Date: Tue, 13 Feb 2007 20:26:23 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Sergei Organov" <osv@javad.com>
Subject: Re: somebody dropped a (warning) bomb
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "=?ISO-8859-1?Q?J.A._Magall=C3=C3=C2=B3n?=" <jamagallon@ono.com>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <87ps8end9b.fsf@javad.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45CB3B28.60102@garzik.org>
	 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
	 <20070208221317.5beedaeb@werewolf-wl>
	 <Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
	 <87abznsdyo.fsf@javad.com>
	 <Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
	 <874pprr5nn.fsf@javad.com>
	 <Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
	 <87ps8end9b.fsf@javad.com>
X-Google-Sender-Auth: 690c86eb4c93ce23
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Sergei Organov <osv@javad.com> wrote:
> May I suggest another definition for a warning being entirely sucks?
> "The warning is entirely sucks if and only if it never has true
> positives." In all other cases it's only more or less sucks, IMHO.

You're totally missing the point. False positives are not a minor
annoyance, they're actively harmful as they hide other _useful_
warnings. So, you really want warnings to be about things that can and
should be fixed. So you really should aim for _zero false positives_
even if you risk not detecting some real positives.

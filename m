Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbXKJPuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbXKJPuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 10:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbXKJPuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 10:50:32 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:27854 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbXKJPub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 10:50:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=p/BEhy/YL2SrbW8wPSZlRLwDGaAhZQZcj3b6jfCruMa8MMwmqYphIOJVgqpnOmr91rijS/AJ7b7MQzWWcUfI/1Rck1rOywt9h1W7fbZ2QEnsFM34IY0pRyJcJvU5TMysR84WDG3p8f3xTwK1v3RW64GpsVU0OCUOAN8c1Z4H/dg=
Message-ID: <4735D341.8090606@gmail.com>
Date: Sat, 10 Nov 2007 16:50:25 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Frank Seidel <fseidel@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/13] Char: nozomi, tty index cleanup
References: <2351011721234832519.slaby@pripojeni.net> <200711101641.44700.fseidel@suse.de>
In-Reply-To: <200711101641.44700.fseidel@suse.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2007 04:41 PM, Frank Seidel wrote:
> On Samstag 10 November 2007 00:45:30, you (Jiri Slaby) wrote:
>> nozomi, tty index cleanup
>>
>> - don't store unneeded copy of tty->index into port structure, tty->index
>>   is available everywhere
>> - mod tty->index by MAX_PORT where expected (otherwise array index out of
>>   bounds)
> The last point i can't retrace, as all those parts were already IMHO.
> NTTY_TTY_MINORS is just an alias for MAX_PORT, but of course its much 
> better readable and also shorter. But i doubt this prevents to an array
> index to get out of bounds ;-)

Aha, this is comment from old patch (before you made the same fixes in c version
of the driver), where I added % in some places, e.g. index of port in dc
structure...

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University

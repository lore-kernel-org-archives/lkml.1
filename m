Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbZKUOXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbZKUOXb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 09:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbZKUOXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 09:23:30 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:60224 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbZKUOX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 09:23:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LY1R55q9iqqzI8QXFTKBP4sphGoEjJw5IVzBFr8OWZ+FBhgQ+63DrcgXG8tqMtUQXm
         yFoRJzQN86WcBdbII6msB5dFPI+4noADnFEtbtl1I8Qqqy8qWs539Ox4A5ydejIm2hyF
         xha2VdRkEk1e6wNPNmgwHXyZtOL2ZMPIiOrCE=
Message-ID: <4B07F7E4.1070207@gmail.com>
Date: Sat, 21 Nov 2009 15:23:32 +0100
From: Martin Fuzzey <mfuzzey@gmail.com>
Reply-To: mfuzzey@gmail.com
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-serial@vger.kernel.org, tsbogend@alpha.franken.de,
       linux-kernel@vger.kernel.org
Subject: Re: Serial: sc26xx device name
References: <4B07F068.1090801@gmail.com> <20091121140911.0e7ef3fd@lxorguk.ukuu.org.uk>
In-Reply-To: <20091121140911.0e7ef3fd@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> 2) How are device name conflicts handled?
>>     
>
> Badly - they should never occur but if someone didn't properly reserve
> the namespace they can and then whoever forgot to reserve the namespace
> loses.
>   
Currently this can't happen because the sc26xx driver uses ttySC205
in contradiction to ttySC0 shown in devices.txt

However if the driver were to be  "fixed" to use the name registered
in devices.txt a conflict could occur if a sc26xx chip were used on
a superH system.

The problem seems to be that while the major/minor numbers in devices.txt
are unique (and the drivers are correctly using their registered numbers),
the _names_ are not unique (at least in this case - I haven't checked for
others).



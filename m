Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbXLSQXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbXLSQXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbXLSQW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:22:57 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:23021 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbXLSQW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:22:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Jh6AQhi/nsA10+Cbv3d4haLfybB96bfvTpRvklgH5ZvXtgnzxM0CKkmCJoVGkypWVne8V4N08LUGnTX5tupshy4jqgQ+xa6RMDkjFcstuu/rTC6V3beSAXl/7E6dcpKXO+Rd/GWbHIXF2yI4b1D/8RD6T7C+zPO2hXpad3hsI9k=
Message-ID: <dfb262380712190822l48f706b5k345762e233b693ae@mail.gmail.com>
Date: Wed, 19 Dec 2007 18:22:55 +0200
From: "Ramagudi Naziir" <naziirr@gmail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: a problem with NETPOLL/KGDBoE
Cc: linux-kernel@vger.kernel.org, jason.wessel@windriver.com
In-Reply-To: <20071206183423.GZ19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dfb262380712061022h43eab6eaxe231b1f81f54d433@mail.gmail.com>
	 <20071206183423.GZ19691@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/6/07, Matt Mackall <mpm@selenic.com> wrote:
> netpoll will ignore incoming UDP -from- the wrong port/ip/mac, since
> it's otherwise bypassing the firewall layer.
...
> I forget how to deal
> with the source address issue in connection with GDB, perhaps Jason
> will remind us.

I have checked it out.
Seems like there is absolutely no way to configure the source
port gdb uses for the udp connection. So one must invoke a
"target remote udp:ip:port" command, see what was the
chosen source port (tcpdump/netstat), and reconfigure kgdb on the target.
While this works, it is rather awkward.

Do you think there is/can be another way to solve this issue
(like allowing NETPOLL to listen to a wildcard udp source port) ?

thank you
naziir
>
> --
> Mathematics is the supreme nostalgia of our time.
>

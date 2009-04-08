Return-Path: <linux-kernel-owner+w=401wt.eu-S1764084AbZDHPWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764084AbZDHPWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbZDHPWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:22:37 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:1944 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbZDHPWg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:22:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xFm/6Qr5J0koY7nxYgjur6p432oSMMp5yQZDSR5uFOplLJ9Xe+nc2tPOlw2UFFNjnU
         /syFJgmMXXt5+YGV1Fzh54qI7Fhr5oSq8eTB3zQyaZSsqeBYNBkjyuHAibVu+ZlS9nd1
         jASV2iKbLmgHzRl7ECGhmc33k3e4Vo0CciBps=
MIME-Version: 1.0
In-Reply-To: <20090331122348.GA31324@hash.localnet>
References: <20090107152208.GB4207@linux.vnet.ibm.com>
	 <25891f3e0902012357n21e7bc2fmc59fb2a842631651@mail.gmail.com>
	 <20090215134702.GA10180@hash.localnet> <49A9C3D7.8060706@gmail.com>
	 <20090330085952.GB3837@linux.vnet.ibm.com>
	 <b6c5339f0903300958m587cde69o44ae24d0609228ba@mail.gmail.com>
	 <20090330175951.GB4199@linux.vnet.ibm.com>
	 <b6c5339f0903301113y6cb0b8bu1eaa55439eb18d97@mail.gmail.com>
	 <20090331035140.GC4199@linux.vnet.ibm.com>
	 <20090331122348.GA31324@hash.localnet>
Date: Wed, 8 Apr 2009 11:22:34 -0400
X-Google-Sender-Auth: 486ad1f7dd9c5230
Message-ID: <b6c5339f0904080822m6129073ahc5caa14c3cd20fd2@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
From: Bob Copeland <me@bobcopeland.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Dhaval Giani <dhaval.lists@thegianis.in>, Jiri Slaby <jirislaby@gmail.com>,
       linux-wireless@vger.kernel.org, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 8:23 AM, Bob Copeland <me@bobcopeland.com> wrote:
> Ok - that is a useful data point.  Perhaps something to do with the rates
> the peer supports; it would help if you could grab a scan next time you
> are in the area.  Turn off auto-connect to open networks, then do:

Hi Dhaval,

Would you mind trying this patch and report the warnings it triggers?

http://marc.info/?l=linux-kernel&m=123915183521347&q=raw

-- 
Bob Copeland %% www.bobcopeland.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbZIJDGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbZIJDGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 23:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbZIJDGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 23:06:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58207 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbZIJDGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 23:06:35 -0400
Message-ID: <4AA86CFA.8090000@zytor.com>
Date: Wed, 09 Sep 2009 20:05:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: Chris Friesen <cfriesen@nortel.com>, Daniel Walker <dwalker@fifo99.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] x86: SGU UV Add volatile semantics to macros that
 access chipset registers
References: <20090909154246.GA26716@sgi.com> <1252512600.14793.125.camel@desktop> <20090909180110.GA10311@sgi.com> <1252519885.14793.135.camel@desktop> <4AA7F9E5.4070506@nortel.com> <20090909193829.GB10530@sgi.com> <4AA84BE7.9010304@zytor.com> <20090910022226.GB10038@sgi.com>
In-Reply-To: <20090910022226.GB10038@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 07:22 PM, Jack Steiner wrote:
> Add volatile-semantics to the SGI UV read/write macros that are
> used to access chipset memory mapped registers. No direct
> references to volatile are made. Instead the readq/writeq
> macros are used.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>

The -q part of readq/writeq is qword, 64 bits.  It looks like you're
replacing references of other sizes with qword references; was that
intended?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


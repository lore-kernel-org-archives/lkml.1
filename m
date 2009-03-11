Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZCKRC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZCKRC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZCKRBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:01:25 -0400
Received: from mail.tpi.com ([70.99.223.143]:4245 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246AbZCKRBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:01:24 -0400
Message-ID: <49B7EE5F.2090803@canonical.com>
Date: Wed, 11 Mar 2009 10:01:19 -0700
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, arobinso@nyx.net
Subject: Re: [PATCH 29/31] esp: Auto-load esp module when device opened.
References: <cover.1236702228.git.scott@canonical.com>	<6a6e566959d30a7e03d677bcb5f68f71d1988e9d.1236702228.git.scott@canonical.com> <20090311134649.00e77e2e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090311134649.00e77e2e@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Wed, 4 Mar 2009 20:55:52 -0700
> Tim Gardner <tim.gardner@canonical.com> wrote:
> 
>> The esp module is missing the char-major-57-* alias that would cause it
>> to be auto-loaded when a device of that type is opened.  This patch adds
>> the alias.
> 
> NAK - the default esp behaviour is to do unsafe ISA probes to find the
> ports. We don't want it autoloading therefore.
> 

Good point. Its been awhile since I had to think about ISA probing.

-- 
Tim Gardner tim.gardner@canonical.com

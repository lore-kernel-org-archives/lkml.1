Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab0BKXPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:15:53 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:51053 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab0BKXPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:15:51 -0500
Date: Fri, 12 Feb 2010 00:15:47 +0100
From: Bastian Blank <waldi@debian.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Stefan Haberland <stefan.haberland@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [11/74] [S390] dasd: fix possible NULL pointer errors
Message-ID: <20100211231547.GA20925@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	stable@kernel.org, stable-review@kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk,
	Stefan Haberland <stefan.haberland@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <20100204171850.GA16539@kroah.com> <20100204171452.915396715@linux.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100204171452.915396715@linux.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 09:11:42AM -0800, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.

Hmm, are such patches not sent to the arch list, linux-s390 in this
case?

Anyway, it breaks without b8ed5dd54895647c2690575aad6f07748c2c618a:
| drivers/s390/block/dasd.c: In function 'dasd_handle_killed_request':
| drivers/s390/block/dasd.c:1008: error: implicit declaration of function 'DBF_EVENT_DEVID'

Bastian

-- 
What kind of love is that?  Not to be loved; never to have shown love.
		-- Commissioner Nancy Hedford, "Metamorphosis",
		   stardate 3219.8

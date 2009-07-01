Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbZGAHUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbZGAHUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZGAHUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:20:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35255 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbZGAHUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:20:22 -0400
Message-ID: <4A4B0C36.4060506@redhat.com>
Date: Wed, 01 Jul 2009 09:11:50 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jonathan Brassow <jbrassow@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 098/108] dm exception store: fix exstore lookup to be
 case insensitive
References: <20090701002249.937782934@mini.kroah.org> <20090701002442.471525145@mini.kroah.org>
In-Reply-To: <20090701002442.471525145@mini.kroah.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 2.6.30-stable review patch.  If anyone has any objections, please let us know.
> commit f6bd4eb73cdf2a5bf954e497972842f39cabb7e3 upstream.

NACK.

this patch must be applied together with commit
 874d2f61d31e596c36af7732dc1b3aa2dc233824  dm exception store: really fix type lookup

or removed from stable because in this form will introduce regression.

Milan
--
mbroz@redhat.com

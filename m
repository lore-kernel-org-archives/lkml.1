Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbYGOGXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbYGOGXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 02:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbYGOGW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 02:22:57 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:35335 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbYGOGW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 02:22:56 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied =?utf-8?q?from=09in-kernel?=, use it in more drivers.
Date: Tue, 15 Jul 2008 08:23:34 +0200
User-Agent: KMail/1.9.9
Cc: david@lang.hm, Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       rene.herman@keyaccess.nl, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <487C0A12.9060906@keyaccess.nl> <alpine.DEB.1.10.0807142241040.6370@asgard> <1216101795.27455.213.camel@shinybook.infradead.org>
In-Reply-To: <1216101795.27455.213.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807150823.35628.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 15 Juli 2008 08:03:15 schrieb David Woodhouse:
> Mostly it follows the documented recommendation, since most of the
> touched drivers are USB drivers and you end up re-enumerating and
> starting from scratch on resume anyway. And the remainder are so old
> that they don't have suspend/resume support anyway. Remember, we're only
> really updating the older drivers; newer drivers tend to use
> request_firmware() already, and have done for years.

As for USB that was before persistance. It now allows you to even
support a loss of power without reprobing, provided

a) the devices does not change IDs
b) you have firmware around when reset_resume() is called

	Regards
		Oliver


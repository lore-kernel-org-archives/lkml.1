Return-Path: <linux-kernel-owner+w=401wt.eu-S1752269AbYLCKkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbYLCKkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 05:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYLCKk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 05:40:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:37931 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbYLCKk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 05:40:27 -0500
Message-ID: <493661FF.8030909@kernel.org>
Date: Wed, 03 Dec 2008 19:39:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jiri Slaby <jirislaby@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       Alexandru Romanescu <a_romanescu@yahoo.co.uk>
Subject: Re: [PATCH 1/1] ATA: piix, fix pointer deref on suspend
References: <1228292026-23586-1-git-send-email-jirislaby@gmail.com> <20081203101342.5041f3fb@lxorguk.ukuu.org.uk>
In-Reply-To: <20081203101342.5041f3fb@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Dec 2008 10:40:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Gak.. Add some kind of helper to the dmi code to do this and do the
> comparison.

It would be best to increase or remove the match limit.  Maybe we
should just bump the limit to eight?

-- 
tejun

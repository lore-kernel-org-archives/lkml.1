Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbXGPGFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbXGPGFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 02:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbXGPGFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 02:05:01 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:44551 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752071AbXGPGFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 02:05:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=U1y7nfsZGeSqWcdUAF51GATRgeUISda6Aw7WtXagwcZBZ7CpYwA/UJlOjwHEEvldaRtzxhQGAkGN5KiQdJioJyAaGbk8/wPjEXeFGDqgdQFBNC/MO6k2B6rgpGtxMp59jS5dE4Lp5OmzhkfUi5djPBFps0Tbwm4wyPhAz4Qqgxc=  ;
X-YMail-OSG: R7rEWEYVM1l1anthD6hy3yqkiCG9LodKs_lqpqWSDmMl5s4S
Message-ID: <469B0A85.3000907@yahoo.com.au>
Date: Mon, 16 Jul 2007 16:04:53 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Al Boldi <a1426z@gawab.com>, Mark Lord <lkml@rtr.ca>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Miklos Szeredi <miklos@szeredi.hu>, jeremy@goop.org, pavel@ucw.cz,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <200707120034.14201.rjw@sisk.pl> <200707120212.24072.a1426z@gawab.com> <200707121520.51250.rjw@sisk.pl>
In-Reply-To: <200707121520.51250.rjw@sisk.pl>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

> The only direct relationship between the freezer and drivers is that some of
> them use kernel threads that call try_to_freeze() (and other freezer-related
> functions).

If removing thoset was the only benefit of getting rid of the freezer
with kexec, it would almost be worth it, IMO :)

-- 
SUSE Labs, Novell Inc.

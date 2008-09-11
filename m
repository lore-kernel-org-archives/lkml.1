Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYIKC1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYIKC1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 22:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYIKC1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 22:27:24 -0400
Received: from web37607.mail.mud.yahoo.com ([209.191.87.90]:32514 "HELO
	web37607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752186AbYIKC1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 22:27:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=TRJRqBaNjuLFNxRrveURvvMoQwdjqPdTpOoJep4inHWg1tomzJK0yRprVhBfRpshsR9SaCxU6lk0ZAp3hl24skG7GFeXPLqe34/AbXqjj4xWe4ewVd6JxKiw77RJSnuyMNHwa81A0sLl3gyRYWEQV1JNYtPpusDEf738JWh9D3E=;
X-YMail-OSG: ojpGZ3YVM1nr0pirQfHCfDgJlzYp5VIQk3ci0sqdy7Lgo4h7WJ6e.66bXSyp2U75gxYq5p4X6NUxZuX31pnnGVAxfto1DHhOZIlSiS0GYW9cgEzGSR4g0AQ5nrl70kS78A9pB6.pZlL6vKouqGwRODM-
X-Mailer: YahooMailWebService/0.7.218.2
Date: Wed, 10 Sep 2008 19:27:22 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Reply-To: oakad@yahoo.com
Subject: Re: [PATCH] memstick: fix MSProHG 8-bit interface mode support
To: oakad@exemail.com.au, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080910174127.faf60c73.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <292368.68991.qm@web37607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




--- On Wed, 9/10/08, Andrew Morton <akpm@linux-foundation.org> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: Re: [PATCH] memstick: fix MSProHG 8-bit interface mode support
> To: oakad@exemail.com.au
> Cc: linux-kernel@vger.kernel.org, oakad@yahoo.com
> Date: Wednesday, September 10, 2008, 5:41 PM
> On Thu, 11 Sep 2008 01:09:55 +1000
> oakad@exemail.com.au wrote:
> 
> > * Fix support of 8-bit interface mode
> 
> what was wrong with it?

It never worked properly. The only adapter I have which supports the
8b mode (the Jmicron) had some problems with its clock wiring and they
discovered it only now. We also discovered that ProHG media is more
sensitive to the ordering of initialization commands.

> 
> > * Make driver to fallback to highest supported mode
> instead of always
> >   falling back to serial
> 
> why?

The driver will attempt the switch to 8b mode for any new MSPro card,
but not all of them support it. Previously, these new cards ended up
in serial mode, which is not the best idea (they work fine with 4b,
after all).




      

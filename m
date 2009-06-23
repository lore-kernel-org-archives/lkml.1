Return-Path: <linux-kernel-owner+w=401wt.eu-S1760292AbZFWXN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292AbZFWXN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759927AbZFWXNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:13:17 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:46488 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760015AbZFWXNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:13:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=e54WnZoydYkug8S2rY1NNbKUZzdcv4ILUCUI0U/cMpaK+5vQPmOe83Q+zue15uE3e1
         WFszUsrss25JzOdzWL1VffFqyREdJe2guVrTqo/40L27BtLa7olpzXgiJ5jZ/vEF5IsG
         DV3WU/6GgEh+Q7+l/eQvrIUG6KPIWx3EcbkJE=
Message-ID: <4A41618D.4020900@laptop.org>
Date: Tue, 23 Jun 2009 19:13:17 -0400
From: "Richard A. Smith" <richard@laptop.org>
Reply-To: richard@laptop.org
Organization: One Laptop per Child
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Andres Salomon <dilinger@collabora.co.uk>, cbou@mail.ru,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: Re: [PATCH 3/5] power_supply: add a TRICKLE_CHARGING status, and
 add it to the olpc driver
References: <20090622234607.11f61bec@mycelium.queued.net> <20090623103717.GH5422@sirena.org.uk> <4A412CC0.6050500@laptop.org> <20090623224434.GB16188@opensource.wolfsonmicro.com>
In-Reply-To: <20090623224434.GB16188@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:

> The problem here is that anything which is already looking at these
> statuses is going to have to be able to cope with the information too.
> In the OLPC case it probably doesn't matter so much if they get
> confused since this is an unusual case but in the embedded case it's
> much more normal (and more likely to happen while a user interacts with
> the device since that tends to burn power which is a problem if you're
> charging off USB).

> A separate file with the detailed information would sidestep this since
> it's a new interface.  I'm not strongly opposed to adding the new states
> but I do think it's worth considering other ways of doing this.

I've got no problems with a new interface.  But, i'm also not the person 
writing the driver. :)

I can change my script to test for the presence of this new interface 
and use that if it exists rather easily.  I already have to handle a few 
cases like that where Andres changed things when I wasn't watching.

Suggestions on what it would look like?

-- 
Richard Smith  <richard@laptop.org>
One Laptop Per Child

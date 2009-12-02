Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbZLBM1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbZLBM1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 07:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZLBM1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 07:27:22 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36493 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZLBM1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 07:27:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=qIp/JiZD+Yng6ryH/hgbuwFeM6Lo1ynXtVqnH9xN9k+Rz8lT+pxpngXcHt9tOYGqH7
         vydmvawE3H/sQskm7V6N3Koh2fuT1cEL7LBQ1quMlOk0IVKZUSjZclvwYqDmM1ED9mzB
         w2uvNaVLdaLGRYauwPdzP6HITcoDHb+80c6TY=
Date: Wed, 2 Dec 2009 13:27:23 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: Ferenc Wagner <wferi@niif.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] intermittent suspend problem again
Message-ID: <20091202132723.2499e4aa@strolchi.home.s3e.de>
In-Reply-To: <87638qw2zy.fsf@tac.ki.iif.hu>
References: <87fx93pwv2.fsf@tac.ki.iif.hu>
	<200912011328.15551.rjw@sisk.pl>
	<877ht68u4h.fsf@tac.ki.iif.hu>
	<200912012232.50951.rjw@sisk.pl>
	<87638qw2zy.fsf@tac.ki.iif.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.1; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Dec 2009 02:58:41 +0100
Ferenc Wagner <wferi@niif.hu> wrote:

> Btw. s2disk has a strange effect of simulating enters during suspend.
> It looks like this in a terminal:
> 
> $ sudo s2disk

...

> 
> 
> 
> 
> 
> 
> $ 
> $ 
> $ 

...

> $ 
> $ 
> $ 
> $ 
> $ <cursor is here>
> 
> Can you also see this?

That's an old "bug" in X (but fixed for me since quite some time) IIUC:
you type s2disk <enter>, s2disk switches to console 1, while enter is
still pressed.
=> X does not know that enter got "released" and will only notice after
resume finished. The X internal key autorepeat does the rest.

Does not happen for me since at least one year, I'd guess, but I am
always running the latest and greatest bleeding edge of everything ;)

HTH,

	seife
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out."

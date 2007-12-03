Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbXLCRCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbXLCRCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 12:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbXLCRCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 12:02:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:31573 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbXLCRCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 12:02:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PgVdl10aNTdqratctEvZ1kIJtmESV5zhR5JJ/dk04s/qicXMosggaeOOq3x17nigmYcpDq7Q3kIxMlH2dQJlYuxKKhJUorws4ao9eRXRL02jqU7/EA8TtCVReYnwyvJBTCM5ROuxKcQPenrAlKLlU7+eRBDT+opuVKasJxOyy/E=
Message-ID: <2c0942db0712030902l16784fa3o43fca831aea2dfcc@mail.gmail.com>
Date: Mon, 3 Dec 2007 09:02:05 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Radoslaw Szkodzinski" <lkml@astralstorm.puszkin.org>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20071203141739.GC4719@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071203110412.GD28560@one.firstfloor.org>
	 <20071203121357.GB2986@one.firstfloor.org>
	 <20071203122833.GA20232@elte.hu>
	 <20071203124144.GC2986@one.firstfloor.org>
	 <20071203130003.GA26372@elte.hu>
	 <20071203131442.GA4004@one.firstfloor.org>
	 <20071203132955.GA31354@elte.hu>
	 <20071203134801.GB4004@one.firstfloor.org>
	 <20071203135547.GA4245@elte.hu>
	 <20071203141739.GC4719@one.firstfloor.org>
X-Google-Sender-Auth: b92c673d10072834
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 3, 2007 6:17 AM, Andi Kleen <andi@firstfloor.org> wrote:
> That won't address my concerns about already "breaking" (as in
> frightening the user etc.) common error handling scenarios by default.

Andi, may I respectfully submit that you're not understanding real users here?

Real users either:
  -  Never look at their syslog
  -  Or look, and aren't terribly scared by what's in there.

Perhaps I'm wrong, and you can point to a message on lkml where
someone has posted a backtrace with fear in their voice.

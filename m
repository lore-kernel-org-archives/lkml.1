Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbYFQExl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbYFQExl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 00:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYFQExb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 00:53:31 -0400
Received: from ag-out-0708.google.com ([72.14.246.250]:32023 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbYFQExb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 00:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=N6lgrFx30eeE7aBDbPtq2Zu0ljPczjTZ6OlJJ7pd+IIZNKIwd1qMoIjUWUrtDroc2Q
         cbe4wBUYiMz8Yuj1fqNX1B4WsBYZTzCcBnm1xA+yNUo1VKpZdgvGSHSHr+h1SvH0rBUt
         9EoZgb86Ek6prfh8haDhfycKhDQeqBd054hUY=
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when
	reading across CPUs.
From: Tom Zanussi <tzanussi@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       akpm@linux-foundation.org, compudj@krystal.dyndns.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com
In-Reply-To: <84144f020806152319w487b67fasa70f2cf27de1d761@mail.gmail.com>
References: <20080613040958.4f52ee29@linux360.ro>
	 <1213417601.8237.37.camel@charm-linux>
	 <20080614181103.17617db1@linux360.ro>
	 <84144f020806140916j7c39d3fr6ada38169ebc84c2@mail.gmail.com>
	 <1213594690.7744.49.camel@charm-linux>
	 <84144f020806152319w487b67fasa70f2cf27de1d761@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 23:52:53 -0500
Message-Id: <1213678374.8259.29.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Pekka,

On Mon, 2008-06-16 at 09:19 +0300, Pekka Enberg wrote:
> Hi Tom,
> 
> On Mon, Jun 16, 2008 at 8:38 AM, Tom Zanussi <tzanussi@gmail.com> wrote:
> > So I guess I don't have strong feelings about it if it's solving a real
> > usability problem and doesn't cause any performance (or other)
> > regressions.
> 
> Is there some standard performance test for relayfs that we could use
> to verify this?

Not that I know of, so probably showing how it would affect/not affect
read and relay_write users with some before/after comparisons would have
to do.

Tom



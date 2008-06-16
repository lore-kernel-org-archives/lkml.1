Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbYFPGTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbYFPGTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYFPGTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:19:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:30578 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbYFPGTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:19:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=HAICM+cukcgQpjND9S8bsJT1ALtin5spSayFL34GqFhZYDuOWi+fNbKHXnuEzuwj4p
         O0on/beXkt5GB0xcWcLKtZ7TWUx6i0kF2oEVDoVFu5LMn/tyENKgiCc2a2SBzcsJchhM
         rdFubQFA+gv9EUrd47HA18DQoq0yEo85p3hZU=
Message-ID: <84144f020806152319w487b67fasa70f2cf27de1d761@mail.gmail.com>
Date: Mon, 16 Jun 2008 09:19:06 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Tom Zanussi" <tzanussi@gmail.com>
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when reading across CPUs.
Cc: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>,
       akpm@linux-foundation.org, compudj@krystal.dyndns.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com
In-Reply-To: <1213594690.7744.49.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080613040958.4f52ee29@linux360.ro>
	 <1213417601.8237.37.camel@charm-linux>
	 <20080614181103.17617db1@linux360.ro>
	 <84144f020806140916j7c39d3fr6ada38169ebc84c2@mail.gmail.com>
	 <1213594690.7744.49.camel@charm-linux>
X-Google-Sender-Auth: 244425962409fa72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

On Mon, Jun 16, 2008 at 8:38 AM, Tom Zanussi <tzanussi@gmail.com> wrote:
> So I guess I don't have strong feelings about it if it's solving a real
> usability problem and doesn't cause any performance (or other)
> regressions.

Is there some standard performance test for relayfs that we could use
to verify this?

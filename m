Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZBIN73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZBIN73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbZBIN7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:59:20 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:45634 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbZBIN7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:59:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qkZrhoAbUqYhILlI1OBTt7C7/LD+3WiZM4oAdDA+mhofBy4hqFVJoFtPON7YDgqcNu
         6C4M5V1zvmX3P90LdIUUee8+7UDVFVIddtIcNR8hoZJqYBaSUoOYDraOlqUy+3ngL+s/
         8AzilgsmqOJ5Nt0v6ztLMWUbzj9LisFJy2ZTc=
MIME-Version: 1.0
In-Reply-To: <sWhNs83kKPE.A.4cG.E30jJB@chimera>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	 <sWhNs83kKPE.A.4cG.E30jJB@chimera>
Date: Mon, 9 Feb 2009 15:59:17 +0200
Message-ID: <8f53421d0902090559n26af97d0i1b8e5f5a04dd6976@mail.gmail.com>
Subject: Re: [Bug #12574] possible circular locking dependency detected
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have verified that this still occurs on 2.6.29-rc4.

On Sun, Feb 8, 2009 at 9:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12574
> Subject         : possible circular locking dependency detected
> Submitter       : Michael S. Tsirkin <m.s.tsirkin@gmail.com>
> Date            : 2009-01-29 11:35 (11 days old)
>
>
>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbZFJOTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbZFJOTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 10:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756735AbZFJOTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 10:19:40 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:38119 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbZFJOTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 10:19:39 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Wed, 10 Jun 2009 16:20:26 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906082233490.19072-100000@netrider.rowland.org> <200906100057.04473.rjw@sisk.pl> <200906101029.27529.rjw@sisk.pl>
In-Reply-To: <200906101029.27529.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906101620.26559.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 10. Juni 2009 10:29:26 schrieb Rafael J. Wysocki:
> Argh, I forgot about some important things.
>
> First, there are devices with no parent (actually, it would be much easier
> if they had a default dummy parent, but that's a separate issue).
>
> Second, the parent has to be taken into account in the asynchronous resume
> path too (which BTW is more complicated).

What happens if the parent's parent is also suspended? It seems to me that
you must code this recursively.

	Regards
		Oliver


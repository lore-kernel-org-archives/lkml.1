Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbYJQVfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbYJQVfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 17:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbYJQVe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 17:34:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:13041 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbYJQVez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 17:34:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=tTkAPzh190EX5oxvFhHR89t7iLY8v0BK6CaZljkPUYkF7BkzGF5+wksk8OAMKu79rc
         gCGMDtGTr3On0iPQCCQEv+kGxHF1JPTyCPpAlWs0iqrVPtKksHioe1RTTbRyisjYp140
         BO7kGaUCyHy7CqeOPQpBEjB0OIXYAd/rDvnlc=
Message-ID: <48F904FA.6090102@gmail.com>
Date: Fri, 17 Oct 2008 23:34:50 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Slightly off topic] A question about R/B trees.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working on my small project, and I need a fast container to hold a large sparse array.
Balanced trees seem to fit perfectly.

I decided to implement a red/black tree, and took a look at kernel rb tree for reference,
and I noticed that tree item has no parent pointer, while it seems that it should have it.

I know now that it has parent pointer, but it is mixed with current and parent node colour.
Thus it is assumed that last two bits of this pointer are zero.

I can see anywhere that this restriction is applied.
I see that structure is "aligned" but that I think only ensures that compiler places it
aligned in static data, does the alignment ensures that it will always place it on aligned address in a structure?
But then, the whole container structure can be misaligned, can't it?

Besides a comment there states that alignment is only for CRIS

How about a check for misalignment?

Best regards,
	Maxim Levitsky

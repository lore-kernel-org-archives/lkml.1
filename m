Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbYAPRO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbYAPRO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbYAPRND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:13:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:51648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757574AbYAPRNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:13:01 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 0 of 4] x86: some more patches
Date: Wed, 16 Jan 2008 18:12:55 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <patchbomb.1200435425@localhost> <20080116154710.GA28946@elte.hu> <478E396A.50707@goop.org>
In-Reply-To: <478E396A.50707@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801161812.55599.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> Also, Andi, do you want to get rid of the PHYSICAL_MASK stuff?

That would be fine, just all the accessors need to mask out NX explicitely.
I didn't have plans to code that up myself though.

-Andi

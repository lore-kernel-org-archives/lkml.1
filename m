Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbZKJRA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbZKJRA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757021AbZKJRA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:00:26 -0500
Received: from burp.tkv.asdf.org ([212.16.99.49]:45275 "EHLO
	cs181073102.pp.htv.fi" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755187AbZKJRAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:00:25 -0500
X-Greylist: delayed 820 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2009 12:00:25 EST
To: linux-kernel@vger.kernel.org
Subject: Re: Using x86 segments against NULL pointer deference exploit
References: <dDwJH-3PE-7@gated-at.bofh.it>
From: Markku Savela <msa@moth.iki.fi>
Date: Tue, 10 Nov 2009 18:46:49 +0200
In-Reply-To: <dDwJH-3PE-7@gated-at.bofh.it> (castet matthieu's message of "Fri\, 06 Nov 2009 14\:10\:01 +0100")
Message-ID: <874op2wcna.fsf@burp.tkv.asdf.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm wondering why on architectures that actually have EXECUTE
permission memory management, the user space is mapped into kernel
with EXECUTE enabled!!!??

If the user space were not mapped with EXECUTE enabled, the
restriction of mapping the 0-page in user space is not required
anymore.



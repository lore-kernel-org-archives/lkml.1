Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbYJ1Jd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbYJ1Jd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 05:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYJ1JdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 05:33:18 -0400
Received: from burp.tkv.asdf.org ([212.16.99.49]:59317 "EHLO
	cs181073102.pp.htv.fi" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751622AbYJ1JdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 05:33:18 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: Silly questions: how can those security_ops->foo(...) calls work when entries seem to be NULL?
References: <brSUc-4iR-25@gated-at.bofh.it>
From: Markku Savela <msa@moth.iki.fi>
Date: Tue, 28 Oct 2008 11:33:15 +0200
In-Reply-To: <brSUc-4iR-25@gated-at.bofh.it> (Markku Savela's message of "Tue\, 28 Oct 2008 10\:20\:12 +0100")
Message-ID: <87ej21njxg.fsf@burp.tkv.asdf.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Blah.. insert foot in mouth -- found: verify() calls
security_fixups(), which modifies the supplied table..

IMHO, misleading name for function, "verify" sort of gives impression
of non-modifying function, and thus got me fooled while reading it..

Sorry about bothering...

-- 
Markku Savela

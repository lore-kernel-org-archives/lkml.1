Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZGGIoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZGGIoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbZGGIob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:44:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43270 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbZGGIoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:44:30 -0400
To: rjw@sisk.pl, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       jkosina@suse.cz
Subject: [regression] 2.6.30 leaking keys on console switch
From: Andi Kleen <andi@firstfloor.org>
Date: Tue, 07 Jul 2009 10:44:32 +0200
Message-ID: <87eiss7uhb.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One new issue I see in 2.6.30 (I think I saw it in some rc*s) too is
that console switch often leaks the Fkey of the console switch into the 
target console.

The symptome is that e.g. firefox if it was active and you're switching
into X displays its help screen (F1 = help). It happens on non X 
consoles too, but of course the symptoms are different here.

That's a regression against 2.6.29; I don't remember it in .29

Haven't investigated code.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

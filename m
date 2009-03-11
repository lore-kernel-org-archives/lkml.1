Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbZCKQVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbZCKQVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZCKQVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:21:34 -0400
Received: from mail-ausfall.charite.de ([193.175.70.131]:34376 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZCKQVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:21:34 -0400
Date: Wed, 11 Mar 2009 17:21:31 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Something is leaking, but what?
Message-ID: <20090311162131.GN11298@charite.de>
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux postamt.charite.de 2.6.29-rc6-git2 #1 SMP Wed Feb 25 17:34:39 CET 2009 i686 GNU/Linux

...
[929292.829382] TCP: Peer 91.37.194.125:57734/993 unexpectedly shrunk window 3527254444:3527303709 (repaired)
[935101.972818] Leak r=1 1
[935124.185293] Leak r=1 1
[935157.494875] Leak r=3 1
[935160.944177] Leak r=1 1
[935204.125721] Leak r=1 1
[935219.851815] Leak r=1 1
[943812.876384] TCP: Peer 84.190.201.56:1136/993 unexpectedly shrunk window 3545663355:3545676423 (repaired)
...

What is it?

-- 
Ralf Hildebrandt                                Ralf.Hildebrandt@charite.de
Charite - Universitätsmedizin Berlin            Tel.  +49 (0)30-450 570-155
Geschäftsbereich IT | Abt. Netzwerk             Fax.  +49 (0)30-450 570-962
Hindenburgdamm 30 | 12200 Berlin

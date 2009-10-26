Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbZJZRT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbZJZRT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZJZRT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:19:26 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:60463 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbZJZRTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:19:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=KUjFUddyHPdww8IPA530th3sLsUBPxOSC03FTCtOJkXohxTl7G6/qbG0fygqEBFmK9
         i+ObwJXsHKGtxu7vetDSuKnpSxAOrE2j5aWiDjSb+zkC+2W0lpXGZKE6E087PvmZlBQa
         eLPl0JBS8yXfDPJcKNC/miqrf8aQUDRMXOdxc=
MIME-Version: 1.0
Date: Mon, 26 Oct 2009 22:49:30 +0530
Message-ID: <f22d86810910261019yc77dbf0sa7688a98e7b98267@mail.gmail.com>
Subject: Difference between atomic operations and memory barriers
From: "Leonidas ." <leonidas137@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to understand difference between atomic ops and memory barriers.

I was thinking all atomic operations must be using barrier internally,
but I read
somewhere that only some of them use barriers. Sorry for being vague here.

Operations before call to smp_mb() will not be re-ordered and all cpus will see
consistent value after the variable is updated.

E.g.
void * ptr = (void *) str;
smb_mb();

Will this not atomically update ptr? Ptr will be seen by all cpu's in
same state
after it has been assigned str, right?

-Leo.

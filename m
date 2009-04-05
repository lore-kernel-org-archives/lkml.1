Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbZDEMbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbZDEMbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 08:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbZDEMbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 08:31:33 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:44234 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbZDEMbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 08:31:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:from:date:message-id:user-agent:mime-version
         :content-type;
        b=uG5zaIKojzeoXTOeV3jKB8WxeiZRPzs36JivY14L0ekln3XCupsycM19htmZhbB6Af
         9IH4pvFiyMWSoaT3poZCbJVK+5jj/jond0whvUbjGMUXyEI1sxEu/DmfvJQ+U48V/84Q
         DWBjOlLqmhkOs+6z3ShRkP6wHme/Nenmi0R9E=
To: linux-kernel@vger.kernel.org
Subject: Issue when switching to jiffies clocksource
From: Francis Moreau <francis.moro@gmail.com>
Date: Sun, 05 Apr 2009 14:31:24 +0200
Message-ID: <m2k55zcmeb.fsf@gmail.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

I just try to switch to 'jiffies' clocksource (by using sysfs interface)
and the system time seems to be no more updated (which causes a lot of
trouble in my system).

I also tried to boot with 'nohz=off' but I got the same behaviour.

So the question is now is this a bug ?

Thanks
-- 
Francis

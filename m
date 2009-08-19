Return-Path: <linux-kernel-owner+w=401wt.eu-S1751568AbZHSByr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbZHSByr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZHSByq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:54:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:65011 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZHSByq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=npMfAWKL9dII/f0J3E6ehzh7M0fyYbHAchjPFiSEExmBDH+3Qy3oBuZvehB84x4Ld/
         mLplX4T8eHthHxNVNAvMor5VdqeMhjXWDJcNfczR9dNX2fkO6Bjtqp6mxB8dHhpIcK9B
         QQDXZRy/Omc1GCy44XrSknRw8cL3wsUt4ZxEQ=
Message-ID: <4A8B5B5C.3050906@gmail.com>
Date: Wed, 19 Aug 2009 10:54:36 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Harald Dunkel <harald.dunkel@t-online.de>,
       =?ISO-8859-2?Q?Fr=E9d=E9ri?= =?ISO-8859-2?Q?c_Weisbecker?= 
	<fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Mahoney <jeffm@suse.com>
Subject: Re: [Bug #13374] reiserfs blocked for more than 120secs
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera> <200908122315.09420.rjw@sisk.pl> <4A8AE52F.6030606@t-online.de> <200908182112.53486.rjw@sisk.pl>
In-Reply-To: <200908182112.53486.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Rafael J. Wysocki wrote:
> Unfortunately, I don't have much experience with debugging issues of
> this kind.  Perhaps Tejun will have some hints (CC added)?

Eh... I don't have much experience either and from the reported
information I can't tell much.  The question would be what the thread
which is holding the lock was doing and whether it traces down to IO
layer.  So, as Jeff said, we'll need sysrq-t output to tell what's
going on.  The current trace only reveals the victim not the offender.

Thanks.

-- 
tejun

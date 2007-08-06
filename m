Return-Path: <linux-kernel-owner+w=401wt.eu-S1763001AbXHFJqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763001AbXHFJqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 05:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760752AbXHFJqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 05:46:00 -0400
Received: from hu-out-0506.google.com ([72.14.214.236]:62576 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760373AbXHFJp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 05:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=M41QddKI7iHRtDrLDJES9S/TgvZzZQabN4Sn2viUfmhQD7AVQDgkbLzZyL5fNYGhRy2CnVWOzjplUhw1P4YY2PoKk1JAoxmoBR9I3yRYu8p6MLiQHilCfuxt+HAGEsd5UZxfMbBfhsVL7tGct7cL4ceU0XUarCvnGerO4qzMwhA=
Message-ID: <46B6EDCB.6030806@gmail.com>
Date: Mon, 06 Aug 2007 11:45:47 +0200
From: dragoran <drago01@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: allow non root users to set io priority "idle" ?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Its possible to set the io priority using tools like ionice and syscalls.
But this works only as root.
Why can't a non root user change the priority of his processes to idle?
I understand that realtime priority requires root but why idle?
For instance the beagle trys to set its priority to idle but fails 
because it does not run as root.
Any reason for this that I have missed? I can't think of a case where 
setting the io priority to idle would have a negative impact for other 
users or the whole system.

P.S:
Please CC me when replying.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbYEMTH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbYEMTH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 15:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757436AbYEMTHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 15:07:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:58498 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003AbYEMTG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 15:06:59 -0400
To: casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.25: access permission filesystem 0.21
References: <126313.89542.qm@web36605.mail.mud.yahoo.com>
From: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Date: Tue, 13 May 2008 21:06:55 +0200
Message-ID: <87k5hy2fcg.fsf@rat.lan>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX184IFZih9tAo40oyJEjaQafe0csUAa48URmPyH
 gZDCZhAsd6nxU1YKPK3d6Yn2770ckWo+4e6LrCbLxn30OGWC5W
 36oM4Zeb+fVkPFatMRWfw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

> --- Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de> wrote:
>
>> This patch adds a new permission managing file system.
>> Furthermore, it adds two modules, which make use of this file system.
>> 
>> One module allows granting capabilities based on user-/groupid.
>
> Hmm. The primary purpose of the capability mechanism, according
> to the POSIX P1003.1e/2c working group*, is to separate the
> privilege mechanism from the userid mechanism. You are now
> reintegrating them two mechanims, albiet differently than
> they were integrated before. You can already achieve this end
> using filesystem based capabilties and mode bits and/or ACLs,
> so why the change?

This idea is from 2002, when there were neither filesystem based
capabilties nor ACLs. But since even I never used it, see it as an
interesting excercise.

>> The
>> second module allows to grant access to lower numbered ports based on
>> user-/groupid, too.
>
> Woof. As reasonable as mode bits on ports seems, there's an
> awful lot of tradition associated with the privileged port
> model. I can see the value in it, I've actually implemented
> it in the past in the Unix world, but I have never seen anyone
> willing to take advantage of the scheme. 

Well, I'm not in the tradition business :-) but it's fun to do these
things and even useful in this case.

Regards, Olaf

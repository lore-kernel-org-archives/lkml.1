Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbYELWGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbYELWGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYELWG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:06:27 -0400
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:46574 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753844AbYELWG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:06:26 -0400
X-YMail-OSG: 2F6_RUwVM1mG9m6DaKoCR8JMzZwc774ZyTULwqgUtYOYnpgxl4SlcibJu6c412UO1L4GCMoC1sX23G_jUF0ThXAVqOrKmPxCtmDHyA--
X-RocketYMMF: rancidfat
Date: Mon, 12 May 2008 15:06:26 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] 2.6.25: access permission filesystem 0.21
To: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <873aon44sr.fsf@rat.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <126313.89542.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de> wrote:

> This patch adds a new permission managing file system.
> Furthermore, it adds two modules, which make use of this file system.
> 
> One module allows granting capabilities based on user-/groupid.

Hmm. The primary purpose of the capability mechanism, according
to the POSIX P1003.1e/2c working group*, is to separate the
privilege mechanism from the userid mechanism. You are now
reintegrating them two mechanims, albiet differently than
they were integrated before. You can already achieve this end
using filesystem based capabilties and mode bits and/or ACLs,
so why the change?

> The
> second module allows to grant access to lower numbered ports based on
> user-/groupid, too.

Woof. As reasonable as mode bits on ports seems, there's an
awful lot of tradition associated with the privileged port
model. I can see the value in it, I've actually implemented
it in the past in the Unix world, but I have never seen anyone
willing to take advantage of the scheme. 


-----
* As I'm the only member of that working group who ever pipes
  up here, you'll have to take my word for it. (smiley)


Casey Schaufler
casey@schaufler-ca.com

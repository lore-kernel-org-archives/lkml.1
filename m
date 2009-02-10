Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbZBJAEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbZBJAEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 19:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbZBJADx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 19:03:53 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:32915 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbZBJADw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 19:03:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P7fajBvMwU4QKMCQTEKcZLspuIzsWXihhP4Dvx6OE7N6h5DBE1YG/Ef/Q6RnIsJR7P
         2QeBHcNznqJDP6smDH60YLkNAZiMI+WvmSVyNp+TtA56sCUKthuTtVj7KTfF4+96jhDZ
         tQYNHKv95E/tsFNSeEZSJcUgNS4dWzO58Rp4U=
MIME-Version: 1.0
In-Reply-To: <1234220548-4791-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1234220548-4791-1-git-send-email-zohar@linux.vnet.ibm.com>
Date: Mon, 9 Feb 2009 19:03:51 -0500
Message-ID: <8bd0f97a0902091603mbab4d50id9790658c5579c15@mail.gmail.com>
Subject: Re: [PATCH] integrity: shmem zero fix
From: Mike Frysinger <vapier.adi@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 18:02, Mimi Zohar wrote:
> Based on comments from Mike Frysinger and Randy Dunlap,
> - moved ima.h include before CONFIG_SHMEM test
> - added 'struct linux_binprm' in ima.h

please move the linux/fs.h include in linux/ima.h to match
linux_binprm location while you're at it
-mike

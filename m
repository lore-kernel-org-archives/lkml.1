Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbYGELgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbYGELgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbYGELgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:36:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:28525 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbYGELgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=MUXhOwypkQHOp6VdbysXmYMjZth7HmppOipjbVbs+EIsBvAeUr14pfh+dkDNq9FIOS
         /qDf3sXU4Z+6EMgEF1pOZRwLG8QtgwCniRuf8I6SimOE2KfvQsoAOSw1ctMUIXTmRgqa
         omJdUWPVAi8hOKt+iArWOityZotkUEwlypihg=
Message-ID: <84144f020807050436h19b18a4bhe4d15163dc31f1c8@mail.gmail.com>
Date: Sat, 5 Jul 2008 14:36:38 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH] Move _RET_IP_ and _THIS_IP_ to include/linux/kernel.h
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080705121423.3a88d20f@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080705121423.3a88d20f@linux360.ro>
X-Google-Sender-Auth: ac161fbe96a7f8a9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 5, 2008 at 12:14 PM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> These two macros are useful beyond lock debugging. Moved definitions from
> include/linux/debug_locks.h to include/linux/kernel.h, so code that needs
> them does not have to include the former, which would have been a less
> intuitive choice of a header.
>
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

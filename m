Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614Ab0A0Jb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab0A0Jb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463Ab0A0Jb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:31:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:45879 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab0A0Jby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:31:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Sdpf8K8VBJxqkN86fY2ToXQFsyKouZvVuL7T5TC/DZqoPfY834693R1ah9D5h0R4aE
         cTDDGg8G5C58Jykp8O67Bra08GwplKUSH+fNi7fk7+HIwEGjDOKIJdO7uUyGjkZGlMep
         6aY0RKjIEMu4iQugvTcEtgIi6etV/3On0BgQ4=
Message-ID: <4B600806.4010003@gmail.com>
Date: Wed, 27 Jan 2010 10:31:50 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org, joe@perches.com,
       bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com,
       shemminger@vyatta.com
Subject: Re: + drivers-block-floppyc-use-pr_level.patch added to -mm tree
References: <201001270037.o0R0bN6S032517@imap1.linux-foundation.org>
In-Reply-To: <201001270037.o0R0bN6S032517@imap1.linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 01:37 AM, akpm@linux-foundation.org wrote:
> @@ -687,9 +687,7 @@ static void __reschedule_timeout(int dri
>  		fd_timeout.expires = jiffies + UDP->timeout;
>  	add_timer(&fd_timeout);
>  	if (UDP->flags & FD_DEBUG) {
> -		DPRINT("reschedule timeout ");
> -		printk(message, marg);
> -		printk("\n");
> +		DPRINT("reschedule timeout %s %d\n", message, marg);

This is wrong.

/me stopped to read here. Recheck the rest of changes.

-- 
js

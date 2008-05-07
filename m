Return-Path: <linux-kernel-owner+w=401wt.eu-S1762855AbYEGHcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762855AbYEGHcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758550AbYEGHbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:31:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:33452 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbYEGHbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:31:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=M99Okib/2TDzQJQA9vApLOFjLPt9BkgqhfzWCTnJ3f43oY9OOdiu32Pyqv79mlxn/BUrO2IwXmXnA8NCgYC1pHS4JrccHxGiE4MCzb9w5yqgpx1y3oQxC00+inMLgBwXMqmdjB04Pvq2kPls5vKgOwKbCZAVoTdo3d/C0c0qsLY=
Message-ID: <48215AD2.7000200@gmail.com>
Date: Wed, 07 May 2008 09:31:30 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 2/3] Add a WARN() macro; this is WARN_ON() + printk arguments
References: <20080506232017.247001e0@infradead.org> <20080506232113.7f066c26@infradead.org>
In-Reply-To: <20080506232113.7f066c26@infradead.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2008 08:21 AM, Arjan van de Ven wrote:
> Subject: Add a WARN() macro; this is WARN_ON() + printk arguments
[...]
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -34,9 +34,13 @@ struct bug_entry {
>  #ifndef __WARN
>  #ifndef __ASSEMBLY__
>  extern void warn_on_slowpath(const char *file, const int line);
> +extern void warn_slowpath(const char *file, const int line, const char *fmt, ...);

__attribute__((format(printf,3,4)))

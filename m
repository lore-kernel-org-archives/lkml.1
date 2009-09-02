Return-Path: <linux-kernel-owner+w=401wt.eu-S1751344AbZIBJrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbZIBJrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 05:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbZIBJrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 05:47:05 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:46044 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZIBJrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 05:47:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kLG6Zrr9lbDxA3u0fbvWcolaWrUOopnpujeGQY7UJTNw3zbUTO0xx2E6baYrbfnGDA
         pNPs6eOEAQY1E8VCaHsIL3mK9pIPkyip0hkiVk7KwdDQercvDYM5PSIp90JcDrGQ7sXQ
         FndPHgeyiUJ6MCmhi5wySn+ZDv/+2fCGFHPk4=
Message-ID: <4A9E3F1A.4050406@gmail.com>
Date: Wed, 02 Sep 2009 11:47:06 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.4 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: oleg@redhat.com, akpm@linux-foundation.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] core: allow setrlimit to non-current tasks
References: <1251884703-14523-1-git-send-email-jirislaby@gmail.com> <1251884703-14523-2-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1251884703-14523-2-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2009 11:45 AM, Jiri Slaby wrote:
> Namely, lock tasklist_lock for read and check whether the task
> structure has signal and sighand non-null. Do all the signal
> processing under that lock still held.

The description is incorrect now, indeed...

And I broke mail threads, sorry.

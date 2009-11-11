Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbZKKAJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbZKKAJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 19:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758724AbZKKAJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 19:09:26 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:53375 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbZKKAJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 19:09:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vOWxFT+TsWGxD7iHcI8oZh6/OhZAZ9fIxVlE0h0tApWUPyrwYYz6ksyJ1n9IKrap94
         AQf488PoVdpXW3awoJXfCpLkvFW8edmnCzkGtLAmK8rZcrllkD+S2PmJH6iUA6MoSIwl
         7MDFqMcMjL2mi8Z3MO83KmBk7FMIjtt5eMn5g=
MIME-Version: 1.0
In-Reply-To: <1257428794-9203-1-git-send-email-tfransosi@gmail.com>
References: <1257428794-9203-1-git-send-email-tfransosi@gmail.com>
Date: Tue, 10 Nov 2009 19:09:30 -0500
Message-ID: <c0c067900911101609v5ca52bb1h98a7bde2cf625ad@mail.gmail.com>
Subject: Re: [PATCH] drivers/serial: remove BAUD_TABLE_SIZE macro.
From: Harik <harik.attar@gmail.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 5, 2009 at 8:46 AM, Thiago Farina <tfransosi@gmail.com> wrote:
> This macro is a duplicated of ARRAY_SIZE defined in kernel api,
> so just use it instead.

> -       UBAUD = PUT_FIELD(UBAUD_DIVIDE,    hw_baud_table[i].divisor) |
> +       UBAUD = PUT_FIELD(UBAUD_DIVIDE,    hw_baud_table[i].divisor) |

Random bit of whitespace got in the patch

Since nobody directly owns this file, CCing maintainers listed for serial_core

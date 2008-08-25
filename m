Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbYHYR2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbYHYR2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYHYR2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:28:15 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:19904 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbYHYR2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jj63NMu7lTENrGT/IaF609OaoryKeFcqw+FwTHGbuqPfd4YAiZdomnoxThFEBYzeJu
         5ALBTlUUl9mxU8oENOI+14HI6a+6IBMa2U+50Awa2J6EeIWPTWeI9GHQvuGzLlJ5rKKc
         /jgGpsoAnfsCyNdjmnBYQwTUkYKbauhwzI7OI=
Message-ID: <86802c440808251028p31edcbeaofa9bbb344e64ba3a@mail.gmail.com>
Date: Mon, 25 Aug 2008 10:28:13 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <198846.67567.qm@web82108.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <198846.67567.qm@web82108.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 6:39 AM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
>
>> this one should work. please apply this one only.
>
> Oops.  Didn't read all my emails first... went through inbox
> one-at-a-time.  (When will I ever learn?...  ;)
>
>
> Results for:  check_res_with_bar_v2.patch
>
> Kernel boots fine.  Massive debugging output follows:
>
> PCI: Using ACPI for IRQ routing
> pci 0000:00:14.0: BAR has HPET at fed00000-fed003ff
> initcall pci_subsys_init+0x0/0x120 returned 0 after 0 msecs

so that works...

YH

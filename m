Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbZHMUq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbZHMUq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZHMUq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:46:27 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:58397 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZHMUq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:46:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=YecoRKrTgTm3qm5IzxghJIKsIjP+nSJc1X3cdvACVQK7Hy4+tv1yCJe1M09ZeAv+cv
         xs1vf678bbveJ1zyfg/3fGINW6Ey8woxgZdxYHWjGFoUyCIeSb2ajdMNVW3xMokuoVGU
         PMOi8eqi0sPZ+gzth7DrEzdIHiN6WcQf58dro=
Message-ID: <4A847BA1.9080805@gmail.com>
Date: Thu, 13 Aug 2009 22:46:25 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-7.4 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Brown, Len" <len.brown@intel.com>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: hibernate causes nobody cared on acpi irq
References: <4A833CAD.5050209@gmail.com> <200908130021.34378.rjw@sisk.pl> <4A846F04.9050005@gmail.com> <200908132220.01334.rjw@sisk.pl>
In-Reply-To: <200908132220.01334.rjw@sisk.pl>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2009 10:20 PM, Rafael J. Wysocki wrote:
> Well, nothing obvious comes to mind.

Hmm, looks like a fresh qemu-kvm bug. noapic fixes that. I never needed
that, but even 2.6.30 doesn't work with it now. Or maybe something on
the host kernel broke recently. -ETOOMANYBUGS. Thanks.

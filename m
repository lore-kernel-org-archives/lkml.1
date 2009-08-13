Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZHMVvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZHMVvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 17:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZHMVvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 17:51:37 -0400
Received: from mail-yw0-f193.google.com ([209.85.211.193]:33593 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbZHMVve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 17:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=d8Yj/i2Ed+5wLfY9VLiek6CP5TEghgWGvWsmBIscOM1jLgzA5KCUPS8HBQHGBE16N5
         RrlrRtfNPIzBb/S3vK0kL44MkkYRI3x6wHDUtpUsKf6/eSQhK9rrwbGYpLu07kRj3off
         X9QipwkgABfT62qogx5blyeh9jGfNdzggq9aw=
Message-ID: <4A848AE2.5010600@gmail.com>
Date: Thu, 13 Aug 2009 23:51:30 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-7.4 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Brown, Len" <len.brown@intel.com>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: hibernate causes nobody cared on acpi irq
References: <4A833CAD.5050209@gmail.com> <200908130021.34378.rjw@sisk.pl> <4A846F04.9050005@gmail.com> <200908132220.01334.rjw@sisk.pl> <4A847BA1.9080805@gmail.com>
In-Reply-To: <4A847BA1.9080805@gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2009 10:46 PM, Jiri Slaby wrote:
> On 08/13/2009 10:20 PM, Rafael J. Wysocki wrote:
>> Well, nothing obvious comes to mind.
> 
> Hmm, looks like a fresh qemu-kvm bug.

FWIW downgrading from kvm userspace 88 to 78 fixed the issue.

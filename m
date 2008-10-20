Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbYJTHzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbYJTHzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYJTHzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:55:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:11550 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbYJTHzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:55:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=YjbZTuhFoAK0jG+Lo38obzO+NEtiViutHBcD3Yoxk3g0cdAxgKF6cGwuPYn57BxRYb
         eMChT0aP4K1VxaxbLZnrfJm/SAIItRlJMRnbFN9IL2W37shq61oxIwuyU6cOFhFJ6f84
         22SBJadWSgxtfu1TXTRuHbnnUPPHU1fWs/GGs=
Message-ID: <7c86c4470810200055u3d8ad80fqac4be901fe529fba@mail.gmail.com>
Date: Mon, 20 Oct 2008 09:55:01 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: [patch 23/24] perfmon3: kernel documentation
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081019133749.GA1546@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f8a9de.1d255e0a.4027.1741@mx.google.com>
	 <20081019133749.GA1546@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

On Sun, Oct 19, 2008 at 3:37 PM, Pavel Machek <pavel@suse.cz> wrote:
> Hi!
>
>> +   * int pfm_create(int flags, pfarg_sinfo_t *s);
>> +
>> +      This function creates a perfmon per-thread session.
>> +      The flags parameter is currently unused and must be set to 0.
>> +
>> +      Upon return and if s is not NULL, the kernel return the list
>> of available
>
> returns?
>
pfm_create() returns the file descriptor identifying the session or -1
in case of error + errno set.

>> +      PMC and PMD registers. Tools should not assume, they have access to the
>> +      entire PMU, it may be shared with other kernel subsystems, e.g., on X86
>> +      the NMI watchdog timer.
>
> How can kernel return anything?
>
I assume you are talking about pfarg_sinfo_t?
That structure contains bitmasks. If not NULL , the kernel updates the
structure to reflect the
list of available registers.

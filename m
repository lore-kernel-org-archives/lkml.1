Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbZIISDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbZIISDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZIISDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:03:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39032 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbZIISDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:03:13 -0400
Message-ID: <4AA7ED79.7080402@zytor.com>
Date: Wed, 09 Sep 2009 11:01:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Arnd Bergmann <arnd@arndb.de>, Nathan Lynch <ntl@pobox.com>,
       linux-kernel@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu,
       torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v5][PATCH 8/8]: Define clone_with_pids() syscall
References: <20090907211302.GA5892@us.ibm.com> <20090907211700.GH6685@us.ibm.com> <m3zl95l2oz.fsf@pobox.com> <200909091419.50496.arnd@arndb.de> <4AA7CF1F.3020408@zytor.com> <20090909180303.GA21048@us.ibm.com>
In-Reply-To: <20090909180303.GA21048@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 11:03 AM, Sukadev Bhattiprolu wrote:
> 
> C90 or C99 below should work. Is it ok to use a data structure that is
> not in C89 ? 
> 

C89 is the same as C90 (C89 refers to the ANSI standard, C90 to the ISO
standard, but they're functionally identical.)

> BTW, would it work if we defined 
> 
> 	struct pid_set {
> 		u64 pids;
> 		int num_pids;
> 	}
> 
> where ->pids can be still be a pointer ? The data structure would
> have the same size on all architectures.
> 

It would rather suck in terms of usability, though.

	-hpa


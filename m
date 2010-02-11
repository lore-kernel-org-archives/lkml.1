Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab0BKWc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 17:32:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35799 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263Ab0BKWcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 17:32:24 -0500
Message-ID: <4B74832B.6050303@kernel.org>
Date: Thu, 11 Feb 2010 14:22:35 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "J.H." <warthog9@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org, users@kernel.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, lasse.collin@tukaani.org
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org> <20100211205129.GA26105@elf.ucw.cz>
In-Reply-To: <20100211205129.GA26105@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2010 12:51 PM, Pavel Machek wrote:
> Hi!
> 
>> Option 1)
>>
>> Leave gz as the master, and migrate bz2 to xz.  This will happen in
>> stages obviously. with bz2 ultimately being phased out.
>>
>> 	Migration option 1)
>>
>> 		All new content would be provided in .bz2 and .xz with
>> 		an ultimate date set that the .bz2 files would stop
>> 		being generated with new content.  This would leave all
>> 		existing content alone and it would not be a migration
>> 		of the current .bz2 files to xz
> 
> I believe this is cleanest. gzip has performance advantages, and old
> files suddenly disappearing would be just weird.
> 

It would also be "just weird" to:

a) require that the end user knows the particular compression format
used by a particular legacy file.
b) having to have the mirror system deal with a mix of .bz2 and .xz files.

	-hpa

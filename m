Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0BHTKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:10:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab0BHTKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:10:02 -0500
Message-ID: <4B70616C.9040901@redhat.com>
Date: Mon, 08 Feb 2010 21:09:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Don Dupuis <dondster@gmail.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: kernel NULL pointer dereference/ kvm subsystem
References: <632b79000910060738l5ed0dd6ch60b4569d87d2ef0e@mail.gmail.com> <20100208172931.GA5315@amt.cnet>
In-Reply-To: <20100208172931.GA5315@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2010 07:29 PM, Marcelo Tosatti wrote:
> On Tue, Oct 06, 2009 at 09:38:05AM -0500, Don Dupuis wrote:
>    
>> Kernel 2.6.31.2
>> x86 64bit
>>
>> Running numerous kvm linux guests and noticed this oops in messages
>> file. This didn't occur in 2.6.30.6
>>
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
>> IP: [<ffffffffa01de29f>] kpit_elapsed+0x30/0x60 [kvm]
>>      
> Fixed by ace1546487a0fe4634e3251067f8a32cb2cdc099.
>
> Greg, can you please cherry pick to 2.6.31.stable?
>    

It's already in, 2.6.31.6 (and I think 31.y is dead).

Rafael, this is #14376.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


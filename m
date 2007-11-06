Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbXKFW6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbXKFW6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 17:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbXKFW5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 17:57:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201AbXKFW5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 17:57:50 -0500
Message-ID: <4730F1AF.8050608@redhat.com>
Date: Tue, 06 Nov 2007 20:58:55 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, avi@qumranet.com, aliguori@us.ibm.com,
       kvm-devel@lists.sourceforge.net, hollisb@us.ibm.com
Subject: Re: include files for kvmclock
References: <11943875362987-git-send-email-gcosta@redhat.com> <11943875433821-git-send-email-gcosta@redhat.com> <4730EF9F.3020803@goop.org>
In-Reply-To: <4730EF9F.3020803@goop.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jeremy Fitzhardinge escreveu:
> Glauber de Oliveira Costa wrote:
>> This patch introduces the include files for kvm clock.
>> They'll be needed for both guest and host part.
>>
>> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
>> ---
>>  include/asm-x86/kvm_para.h |   23 +++++++++++++++++++++++
>>  include/linux/kvm.h        |    1 +
>>  include/linux/kvm_para.h   |   20 ++++++++++++++++++++
>>  3 files changed, 44 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/asm-x86/kvm_para.h b/include/asm-x86/kvm_para.h
>> index c6f3fd8..af9fb75 100644
>> --- a/include/asm-x86/kvm_para.h
>> +++ b/include/asm-x86/kvm_para.h
>> @@ -10,15 +10,38 @@
>>   * paravirtualization, the appropriate feature bit should be checked.
>>   */
>>  #define KVM_CPUID_FEATURES	0x40000001
>> +#define KVM_FEATURE_CLOCKEVENTS 0
>> +#define KVM_FEATURE_CLOCKSOURCE 1
>> +
>>  
>>  #ifdef __KERNEL__
>>  #include <asm/processor.h>
>> +extern void kvmclock_init(void);
>> +
>> +union kvm_hv_clock {
>>   
> 
> Why two copies of this structure?
> 
It's called silly mistake. ;-)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHMPGvjYI8LaFUWXMRAgt2AJ9NKgq2LCueUidH56ZgUYA+5wBhGwCfdqQB
otFP1/SFowaANQ8FojEtJUE=
=8Xqp
-----END PGP SIGNATURE-----

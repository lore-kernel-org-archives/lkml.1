Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbZJNAvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbZJNAvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 20:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZJNAva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 20:51:30 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:57040 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbZJNAv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 20:51:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CNGAGYsM4wHcLC96Z260UKWyzX2U700/oZoIE/PdeqhIANKUDzcnakZ0hyAb4f1+VM
         XBD8oovCObGtz9ec2ChOFmfrToaM7R4boQT+MNROdtjgHT9QvUdDHnXQ6h4N36zeGec2
         adghsylHgMc3PObPW9+6ymZG9xp1jiyNR0e1g=
MIME-Version: 1.0
In-Reply-To: <4AD51A7C.9060207@canonical.com>
References: <43e72e890910131542k376a87c5rc30feb6491a06867@mail.gmail.com> 
	<4AD51A7C.9060207@canonical.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 13 Oct 2009 17:50:33 -0700
Message-ID: <43e72e890910131750s4d2cdb20o76d721087d9b3aaf@mail.gmail.com>
Subject: Re: Stable compat-wireless 2.6.32-rc4 released
To: tim.gardner@canonical.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 5:25 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
> Luis R. Rodriguez wrote:
>>
>> As the kernel moves along so does the automatic stable backports for
>> the wireless subsystem [1]. We are now on 2.6.32-rc4. Besides getting
>> the same fixes from rc1..rc4 some backport changes were made as well,
>> most importantly that of relying on your own kernel's iw_handler.h.
>> I've tested this release with 2.6.28.
>>
>> Please report any issues you see.
>>
>> [1] http://wireless.kernel.org/en/users/Download/stable
>>
>> PS. If you maintain a distribution and rely on stable compat-wireless
>> releases please let me know so I can CC you when further updates are
>> made.
>>
>>  Luis
>>
>
> Speaking as a distro, what advantage does the stable wireless backport offer
> for the currently released kernel if we are already consumers of stable
> updates?

Well if you are a distro stuck on the 2.6.31 kernel the stable
compat-wireless-2.6.32 gets you 2.6.32 wireless bits on 2.6.31 and
that means any features/drivers/large fixes/enhancements that didn't
make it to 2.6.31.

  Luis

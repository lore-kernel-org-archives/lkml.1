Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbZF3Sog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbZF3Sog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 14:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbZF3So1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 14:44:27 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:40630 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbZF3So1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 14:44:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qFCmwHU1M5Y4mMa4WfplKWsezrtVzxVrV6bE9VfMuHNXgfVu+FlmkiV9XT6SJYwMVo
         NiD8rYoWfb5x5EfijD8IWPv3xLb7zAAqYYF/aRd7CGcNlJfVD71pRCbxjA0rEq01laEy
         awtRyrrdQNyLHlLTGqDJ/RZMA+keyWwcVh95g=
MIME-Version: 1.0
In-Reply-To: <20090630075457.GH20289@redhat.com>
References: <20090630064515.GG20289@redhat.com>
	 <86802c440906300018p8c5156dy3e8d84b8c263797e@mail.gmail.com>
	 <20090630075457.GH20289@redhat.com>
Date: Tue, 30 Jun 2009 11:43:41 -0700
Message-ID: <86802c440906301143s14d0cc9ej9b666271a1ce15ba@mail.gmail.com>
Subject: Re: [PATCH v4] enable x2APIC without interrupt remapping under KVM
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Gleb Natapov <gleb@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/30 Gleb Natapov <gleb@redhat.com>:

>>
>> how about kexec second kernel in KVM ?
>>
>> x2apic_preenabled will be set in second kernel.
>>
> Yes, bummer. But the similar problem exist now and without KVM. After
> running x2apic enabled kernel you can't kexec kernel without x2apic
> support.

if the first kernel enable x2apic and intr_remapping, and second
kernel has x2apic and intr_remap support.
we can kexec the second kernel.

restoring to original state is not possible for kdump case.

maybe with minor change to your patch, you could kexec the in kexec
second kernel with x2apic support.

YH

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758412AbZGAFNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412AbZGAFNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 01:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbZGAFNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 01:13:43 -0400
Received: from smtp-out.google.com ([216.239.45.13]:39444 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbZGAFNm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 01:13:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=XD2vNLWhx2V/077jJ9X3yHsLHnfNWomX+i11cYn3BNLNj32YrP14FzwUbGvwpSxtU
	tLzsN4Nn2TqslSyrBOoiQ==
MIME-Version: 1.0
In-Reply-To: <20090701004046.GA13013@hexapodia.org>
References: <20cbb9450906112259m176153c9ucfa7a4d14642949f@mail.gmail.com>
	 <1244817141.3401.7.camel@dyn9002018117.watson.ibm.com>
	 <4A3474BD.4000804@linux.vnet.ibm.com>
	 <b8394ab90906140015h793aaf51rb9b105910e61fa1@mail.gmail.com>
	 <1245007238.10712.5.camel@blackbox>
	 <1245068894.3247.22.camel@dhcp231-142.rdu.redhat.com>
	 <4A367093.6010206@linux.vnet.ibm.com>
	 <20090701004046.GA13013@hexapodia.org>
Date: Wed, 1 Jul 2009 14:13:39 +0900
Message-ID: <b8394ab90906302213h4551795fsa55c6747f4fea94@mail.gmail.com>
Subject: Re: [tpmdd-devel] TPM drivers support and Linux Integrity Module for 
	2.6.30
From: =?UTF-8?B?ZGRzICjimJUp?= <dds@google.com>
To: Andy Isaacson <adi@hexapodia.org>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       tpmdd-devel@lists.sourceforge.net, seiji.munetoh@gmail.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy, what do your patches do?

On Wed, Jul 1, 2009 at 9:40 AM, Andy Isaacson<adi@hexapodia.org> wrote:
> On Mon, Jun 15, 2009 at 01:02:27PM -0300, Rajiv Andrade wrote:
>> Yep, sorry. Two options:
>>
>> 1- Inside that check, if got an error when in that particular
>> tpm_getcap() stacked call, consider that it might be this iTPM, and
>> bypass it just to get the value from the chip (would happen only once) -
>> Would work, but it's odd.
>>
>> 2- Forget manufacturer_id and base the decision on the PNP_ID as david
>> suggested. I previously considered it but since it would end up in
>> modifying tpm_tis_init() prototype (struct device * to struct pnp_dev *)
>> and then wouldn't work when loading as a module with force option on, so
>> I moved to the manufacturer_id approach.
>>
>> I'll get back to #2 meanwhile and post the patch, seems not hard to
>> accomplish though..
>
> I've got a set of patches that seem to resolve my iTPM woes.  I've
> mostly tested on T400 but I also tried X200.
>
> I'll send the patches as a separate thread (unfortunately I can't get
> git-send-email 1.6.3.1 to set a in-reply-to header on 0/5 without also
> breaking threading on x/5.)
>
> -andy
>
> ------------------------------------------------------------------------------
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>

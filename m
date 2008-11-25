Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbYKYLag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbYKYLag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbYKYLa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:30:28 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:50543 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYKYLa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:30:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cLPnF7aAfQuEbF7jXuz/eYBWfXa+uojHa5PBomRrpqbJSL7oON4Vws90EG902rdYY3
         PO00i2r3Wae2qbUfz+/0/RfGU7ZqSMbtQWMr1Wl8MHkwzJjkvqHUtIn69K7SgpznpVmT
         5dj+TTpTdftDsvRihYU4DCqjF5RV6SS4Wmaoo=
Message-ID: <c62985530811250330y5c4b2bb0m2a238d7510dc5f79@mail.gmail.com>
Date: Tue, 25 Nov 2008 12:30:26 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: [patch 9/9] x86, bts, ftrace: a BTS ftrace plug-in prototype
Cc: "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E08F3C3A1@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081125092415.A31432@sedona.ch.intel.com>
	 <c62985530811250239v4a51cd1p4de5f1616a41ef36@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F3C3A1@irsmsx504.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/25 Metzger, Markus T <markus.t.metzger@intel.com>:
>>If you look at the struct trace_entry, you will see find the cpu
>>field. It is already inserted automatically :-)
>
> I am using that field in struct trace_entry.


Right, I misread.


> Without the assignment, though, I've seen funny cpu numbers. It seems that the field is not filled automatically.
>

Sorry, I thought it was done by tracing_generic_entry_update() but all
of the fields in struct trace_entry are filled inside
this function except the cpu one.... Perhaps it should, I don't know.

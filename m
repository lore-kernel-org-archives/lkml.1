Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZELQlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZELQlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbZELQkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:40:53 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:47218 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbZELQkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:40:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OIAyZBiaiIXF5ww80gCSryj5lFwTRwpQDjzCPyqqjss/hBeZXNvzlLDmYwpsAXgc8U
         vuXvXMfvdXR+ItcgWNd7a4jTSChf9Yubn7V8QEsHtjMazNgbA21ZaX7hb+B4pwmMKHnj
         Q/6W+9PUhYnuHZ0tI/GiJfprbUMEUz9WsUgSU=
MIME-Version: 1.0
In-Reply-To: <20090512161605.GB19747@sgi.com>
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org>
	 <20090511175312.GA27905@sgi.com>
	 <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com>
	 <4A0894A5.9000209@zytor.com>
	 <alpine.DEB.2.00.0905111509570.2234@chino.kir.corp.google.com>
	 <20090512150622.GA10015@sgi.com>
	 <86802c440905120810x6ea4b228t14ca19376dc13f13@mail.gmail.com>
	 <20090512161605.GB19747@sgi.com>
Date: Tue, 12 May 2009 09:40:52 -0700
Message-ID: <86802c440905120940r3d3261dap9d1843a9c832b582@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jack Steiner <steiner@sgi.com>
Cc: David Rientjes <rientjes@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001e680f16fc11bd120469b9c2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001e680f16fc11bd120469b9c2a4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Tue, May 12, 2009 at 9:16 AM, Jack Steiner <steiner@sgi.com> wrote:
> On Tue, May 12, 2009 at 08:10:18AM -0700, Yinghai Lu wrote:
>> jack,
>>
>> can you confirm:
>> 1. without this patch, your system still have problem?
>> 2. does current tip/master work for you?
>
> The current tip/master fails with or without the patch. AFAICT, the
> failure is identical in both cases.

ok, can you try attach patch to check cpu_to_node mapping?

YH

--001e680f16fc11bd120469b9c2a4
Content-Type: text/x-patch; charset=US-ASCII; name="debug_extra_numa_init_node.patch"
Content-Disposition: attachment; filename="debug_extra_numa_init_node.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fumttmav0

U3ViamVjdDogW1BBVENIXSB4ODY6IGV4dHJhIGRlYnVnIGZvciBjcHVfdG9fbm9kZSBtYXBwaW5n
CgpwcmludCBtb3JlIGluZm8gYWJvdXQgY3B1IG5vZGUgbWFwcGluZyBmaW5hbGx5ID8KClNpZ25l
ZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KCi0tLQogYXJjaC94ODYv
bW0vbnVtYV82NC5jIHwgICAxMSArKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDExIGluc2Vy
dGlvbnMoKykKCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYvbW0vbnVtYV82NC5jCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L21tL251bWFfNjQuYworKysgbGludXgtMi42
L2FyY2gveDg2L21tL251bWFfNjQuYwpAQCAtNjMzLDYgKzYzMywxNyBAQCB2b2lkIF9faW5pdCBp
bml0X2NwdV90b19ub2RlKHZvaWQpCiAJCQljb250aW51ZTsKIAkJbnVtYV9zZXRfbm9kZShjcHUs
IG5vZGUpOwogCX0KKwlwcmludGsoS0VSTl9JTkZPICJpbml0X2NwdV90b19ub2RlOlxuIik7CisJ
Zm9yX2VhY2hfcG9zc2libGVfY3B1KGNwdSkgeworCQlpbnQgbm9kZTsKKwkJdTE2IGFwaWNpZDsK
KwkJbm9kZSA9IGVhcmx5X2NwdV90b19ub2RlKGNwdSk7CisJCWlmIChub2RlID09IE5VTUFfTk9f
Tk9ERSkKKwkJCWNvbnRpbnVlOworCQlhcGljaWQgPSBjcHVfdG9fYXBpY2lkW2NwdV07CisJCXBy
aW50ayhLRVJOX0lORk8gImNwdSAlZCAtPiBhcGljaWQgJSN4IC0+IG5vZGUgJWRcbiIsCisJCQkJ
IGNwdSwgYXBpY2lkLCBub2RlKTsKKwl9CiB9CiAjZW5kaWYKIAo=
--001e680f16fc11bd120469b9c2a4--

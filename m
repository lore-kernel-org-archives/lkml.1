Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbZJMMs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbZJMMs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757023AbZJMMs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:48:26 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:36818 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZJMMsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:48:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oQhYGGeALC8rCm+wXP+cEiYT90vQQhQ2k1hVu8NpzwNsJoyGiAoAvqDKudq5BfvxXh
         EnWIF1F1mFkWe2k9fcAireIVnXvQ4GvXHNtUyEN2XeeKNVDmtoYcyVLsxwxqK+4FSjjy
         pkvZNoHsJIlaYPNRT9wDQUzEJ9+MPUaDG+dYE=
MIME-Version: 1.0
In-Reply-To: <20091013122720.GA5561@elte.hu>
References: <4727185d0910130118m5387058dndb02ac9b384af9f0@mail.gmail.com>
	 <20091013100101.GA26846@elte.hu>
	 <4727185d0910130451h3a5adcebtc0c06f48b6c9ab99@mail.gmail.com>
	 <20091013122720.GA5561@elte.hu>
Date: Tue, 13 Oct 2009 14:48:14 +0200
Message-ID: <4727185d0910130548p325f0185vf4e23b5491c730a0@mail.gmail.com>
Subject: Re: [PATCH] [PERF] do not manually count string lengths
From: Vincent Legoll <vincent.legoll@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, paulus@samba.org,
       a.p.zijlstra@chello.nl
Content-Type: multipart/mixed; boundary=0016e6d78426a213330475d07547
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d78426a213330475d07547
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Oct 13, 2009 at 2:27 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> Was your list really comprehensive ?
>
> ah, yes - perf_callchain.c too indeed. The pattern does not have to be
> 100% full coverage.

How looks the attached ?

-- 
Vincent Legoll

--0016e6d78426a213330475d07547
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0001-Update-performance-events-subsystem-maintainers-entr.patch"
Content-Disposition: attachment; 
	filename="0001-Update-performance-events-subsystem-maintainers-entr.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g0qnen0s0

RnJvbSA3NGVmN2NmOTlkMWM1NDE1NzcxYTRjN2M5OGU3MmUyNDczMzllYmU2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWaW5jZW50IExlZ29sbCA8dmluY2VudC5sZWdvbGxAZ21haWwu
Y29tPgpEYXRlOiBUdWUsIDEzIE9jdCAyMDA5IDE0OjQxOjQ2ICswMjAwClN1YmplY3Q6IFtQQVRD
SF0gVXBkYXRlIHBlcmZvcm1hbmNlIGV2ZW50cyBzdWJzeXN0ZW0gbWFpbnRhaW5lcnMgZW50cnkK
CkFkZCBmaWxlIHBhdHRlcm5zIHRoYXQgbWF0Y2ggcmVsZXZhbnQgZmlsZXMgZm9yIHRoaXMKc3Vi
c3lzdGVtLgoKU2lnbmVkLW9mZi1ieTogVmluY2VudCBMZWdvbGwgPHZpbmNlbnQubGVnb2xsQGdt
YWlsLmNvbT4KLS0tCiBNQUlOVEFJTkVSUyB8ICAgIDcgKysrKysrKwogMSBmaWxlcyBjaGFuZ2Vk
LCA3IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvTUFJTlRBSU5F
UlMgYi9NQUlOVEFJTkVSUwppbmRleCA2OWUzMWFhLi5jZjY5MDkxIDEwMDY0NAotLS0gYS9NQUlO
VEFJTkVSUworKysgYi9NQUlOVEFJTkVSUwpAQCAtNDA3MSw2ICs0MDcxLDEzIEBAIE06CVBldGVy
IFppamxzdHJhIDxhLnAuemlqbHN0cmFAY2hlbGxvLm5sPgogTToJUGF1bCBNYWNrZXJyYXMgPHBh
dWx1c0BzYW1iYS5vcmc+CiBNOglJbmdvIE1vbG5hciA8bWluZ29AZWx0ZS5odT4KIFM6CVN1cHBv
cnRlZAorRjoJa2VybmVsL3BlcmZfZXZlbnQuYworRjoJaW5jbHVkZS9saW51eC9wZXJmX2V2ZW50
LmgKK0Y6CWFyY2gvKi8qL2tlcm5lbC9wZXJmX2V2ZW50LmMKK0Y6CWFyY2gvKi9pbmNsdWRlL2Fz
bS9wZXJmX2V2ZW50LmgKK0Y6CWFyY2gvKi9saWIvcGVyZl9ldmVudC5jCitGOglhcmNoLyova2Vy
bmVsL3BlcmZfY2FsbGNoYWluLmMKK0Y6CXRvb2xzL3BlcmYvCiAKIFBFUlNPTkFMSVRZIEhBTkRM
SU5HCiBNOglDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGluZnJhZGVhZC5vcmc+Ci0tIAoxLjYuMC40
Cgo=
--0016e6d78426a213330475d07547--

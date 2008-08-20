Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbYHTROy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbYHTROy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYHTROp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:14:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:1497 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbYHTROo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:14:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=pxgh7SSJomWvKi25CDYTkf1qUsMnA0bBaxiX1ZMIlfXDhrpZMkl0gIumB+qa6BLJF0
         gIUZYppdrmGXsSO4KrgbcNlJuXB2hvjuQyv4a1Jbf0P0M5TW56vV4StX9edwhnAwdTrT
         USr3DkHdLj00gf8A/KHT20wYOzyHGABucJKCc=
Message-ID: <520f0cf10808201014q3b9388fak99d1c95abea9e455@mail.gmail.com>
Date: Wed, 20 Aug 2008 19:14:42 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] rt Kconfig.preempt fixes
Cc: rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0808201207470.27481@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_46553_11285296.1219252482433"
References: <520f0cf10808010639y4c1a19a7kff429827d26dc8e9@mail.gmail.com>
	 <alpine.DEB.1.10.0808201207470.27481@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_46553_11285296.1219252482433
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Aug 20, 2008 at 6:10 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
>
> On Fri, 1 Aug 2008, John Kacur wrote:
>
>> This is a non-critical patch, that makes configuring an rt kernel a
>> little nicer.
>> Comments are welcome of course.
>>
>> Signed-off-by: John Kacur <jkacur at gmail dot com>
>>
>> This patch makes the following changes.
>> 1. Hides the visibility of PREEMPT_SOFTIRQS and PREEMPT_HARDIRQS if PREEMPT_RT
>> (Complete Preemption) is choosen, since these values are then set (selected) to
>> be "y".
>>
>> 2. Changes the PREEMPT_HARDIRQS to depend on PREEMPT_SOFTIRQS instead of
>> forcing PREEMPT_SOFTIRQS to y if PREEMPT_HARDIRQS is choosen. (this is somewhat
>> an abuse of select)
>>
>> 3. Minor spelling fix. (tat to that)
>>
>
>
> Hi John,
>
> Thanks, but instead of this:
>
>  depends on PREEMPT_RT != y
>
> could you do:
>
>  depends on !PREEMPT_RT
>
>
> -- Steve
>

Yes, regenerated patch attached.

Thanks

------=_Part_46553_11285296.1219252482433
Content-Type: text/x-patch; name=threaded-irqs-kconfig-fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fk47eift0
Content-Disposition: attachment; filename=threaded-irqs-kconfig-fix.patch

U2lnbmVkLW9mZi1ieTogSm9obiBLYWN1ciA8amthY3VyIGF0IGdtYWlsIGRvdCBjb20+CgpUaGlz
IHBhdGNoIG1ha2VzIHRoZSBmb2xsb3dpbmcgY2hhbmdlcy4KMS4gSGlkZXMgdGhlIHZpc2liaWxp
dHkgb2YgUFJFRU1QVF9TT0ZUSVJRUyBhbmQgUFJFRU1QVF9IQVJESVJRUyBpZiBQUkVFTVBUX1JU
CihDb21wbGV0ZSBQcmVlbXB0aW9uKSBpcyBjaG9vc2VuLCBzaW5jZSB0aGVzZSB2YWx1ZXMgYXJl
IHRoZW4gc2V0IChzZWxlY3RlZCkgdG8KYmUgInkiLgoKMi4gQ2hhbmdlcyB0aGUgUFJFRU1QVF9I
QVJESVJRUyB0byBkZXBlbmQgb24gUFJFRU1QVF9TT0ZUSVJRUyBpbnN0ZWFkIG9mCmZvcmNpbmcg
UFJFRU1QVF9TT0ZUSVJRUyB0byB5IGlmIFBSRUVNUFRfSEFSRElSUVMgaXMgY2hvb3Nlbi4gKHRo
aXMgaXMgc29tZXdoYXQKYW4gYWJ1c2Ugb2Ygc2VsZWN0KQoKMy4gTWlub3Igc3BlbGxpbmcgZml4
LiAodGF0IHRvIHRoYXQpCgpJbmRleDogbGludXgtMi42LjI2LjItcnQxLWprL2tlcm5lbC9LY29u
ZmlnLnByZWVtcHQKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42LjI2LjItcnQxLWprLm9yaWcva2Vy
bmVsL0tjb25maWcucHJlZW1wdAorKysgbGludXgtMi42LjI2LjItcnQxLWprL2tlcm5lbC9LY29u
ZmlnLnByZWVtcHQKQEAgLTg4LDggKzg4LDEwIEBAIGNvbmZpZyBQUkVFTVBUCiAKIGNvbmZpZyBQ
UkVFTVBUX1NPRlRJUlFTCiAJYm9vbCAiVGhyZWFkIFNvZnRpcnFzIgorIyBQUkVFTVBUX1NPRlRJ
UlFTIGlzIHZpc2libGUgb25seSBpZiAhUFJFRU1QVF9SVAorIyBIb3dldmVyLCBQUkVFTVBUX1JU
IHdpbGwgc2V0IChzZWxlY3QpIFBSRUVNUFRfU09GVElSUVMgdG8geQorCWRlcGVuZHMgb24gIVBS
RUVNUFRfUlQKIAlkZWZhdWx0IG4KLSMJZGVwZW5kcyBvbiBQUkVFTVBUCiAJaGVscAogCSAgVGhp
cyBvcHRpb24gcmVkdWNlcyB0aGUgbGF0ZW5jeSBvZiB0aGUga2VybmVsIGJ5ICd0aHJlYWRpbmcn
CiAgICAgICAgICAgc29mdCBpbnRlcnJ1cHRzLiBUaGlzIG1lYW5zIHRoYXQgYWxsIHNvZnRpcnFz
IHdpbGwgZXhlY3V0ZQpAQCAtMTA0LDkgKzEwNiwxMiBAQCBjb25maWcgUFJFRU1QVF9TT0ZUSVJR
UwogCiBjb25maWcgUFJFRU1QVF9IQVJESVJRUwogCWJvb2wgIlRocmVhZCBIYXJkaXJxcyIKKyMg
UFJFRU1QVF9IQVJESVJRUyBpcyB2aXNpYmxlIG9ubHkgaWYgIVBSRUVNUFRfUlQKKyMgSG93ZXZl
ciwgUFJFRU1QVF9SVCB3aWxsIHNldCA4c2VsZWN0KSBQUkVFTVBUX0hBUkRJUlFTIHRvIHkKKwlk
ZXBlbmRzIG9uICFQUkVFTVBUX1JUCiAJZGVmYXVsdCBuCiAJZGVwZW5kcyBvbiAhR0VORVJJQ19I
QVJESVJRU19OT19fRE9fSVJRCi0Jc2VsZWN0IFBSRUVNUFRfU09GVElSUVMKKwlkZXBlbmRzIG9u
IFBSRUVNUFRfU09GVElSUVMKIAloZWxwCiAJICBUaGlzIG9wdGlvbiByZWR1Y2VzIHRoZSBsYXRl
bmN5IG9mIHRoZSBrZXJuZWwgYnkgJ3RocmVhZGluZycKICAgICAgICAgICBoYXJkaXJxcy4gVGhp
cyBtZWFucyB0aGF0IGFsbCAob3Igc2VsZWN0ZWQpIGhhcmRpcnFzIHdpbGwgcnVuCkBAIC0xNDEs
NyArMTQ2LDcgQEAgY29uZmlnIFBSRUVNUFRfUkNVX0JPT1NUCiAJZGVmYXVsdCB5IGlmIFBSRUVN
UFRfUlQKIAloZWxwCiAJICBUaGlzIG9wdGlvbiBwZXJtaXRzIHByaW9yaXR5IGJvb3N0aW5nIG9m
IFJDVSByZWFkLXNpZGUgY3JpdGljYWwKLQkgIHNlY3Rpb25zIHRhdCBoYXZlIGJlZW4gcHJlZW1w
dGVkIGFuZCBhIFJUIHByb2Nlc3MgaXMgd2FpdGluZworCSAgc2VjdGlvbnMgdGhhdCBoYXZlIGJl
ZW4gcHJlZW1wdGVkIGFuZCBhIFJUIHByb2Nlc3MgaXMgd2FpdGluZwogCSAgb24gYSBzeW5jaHJv
bml6ZV9yY3UuCiAKIAkgIEFuIFJDVSB0aHJlYWQgaXMgYWxzbyBjcmVhdGVkIHRoYXQgcGVyaW9k
aWNhbGx5IHdha2VzIHVwIGFuZAo=
------=_Part_46553_11285296.1219252482433--

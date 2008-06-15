Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYFOTSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYFOTSw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 15:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYFOTSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 15:18:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:43813 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbYFOTSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 15:18:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=VKJjnnfEnxI/WiiHsTG5qCKbkEU3FsfjtikSkdet7CqWhylFEW9w+IF1DBXU3QaHyH
         bWyq1MI1NBNHzGPbkfox+s4THbkey4guKymbrLOGlkAJvU9d3jnyOG4g5wnI/kMSyA1G
         udaMDkUBQMJrbSj2hTShArhE7zmgd6WzCS1rw=
Message-ID: <86802c440806151218h7b8b6c80q4ce0f6505244e588@mail.gmail.com>
Date: Sun, 15 Jun 2008 12:18:42 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [Bug 10872] x86_64 boot hang when CONFIG_NUMA=n
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080615093543.1b18b9eb.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_10955_7710511.1213557522587"
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	 <Jn7irxIunJK.A.8UD.1IDVIB@albercik>
	 <20080615093543.1b18b9eb.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_10955_7710511.1213557522587
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Jun 15, 2008 at 9:35 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Sat, 14 Jun 2008 22:12:04 +0200 (CEST) Rafael J. Wysocki wrote:
>
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.25.  Please verify if it still should be listed.
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=10872
>> Subject               : x86_64 boot hang when CONFIG_NUMA=n
>> Submitter     : Randy Dunlap <randy.dunlap@oracle.com>
>> Date          : 2008-06-05 21:50 (10 days old)
>> References    : http://marc.info/?l=linux-kernel&m=121270308607116&w=4
>>                 http://lkml.org/lkml/2008/6/11/355
>> Handled-By    : Yinghai Lu <yhlu.kernel@gmail.com>
>
> Yes, still happens for me on 2.6.26-rc6-git2.
>

please send out whole boot log with numa on and numa off
and boot with debug

please apply attached debug patch too.

YH

------=_Part_10955_7710511.1213557522587
Content-Type: text/x-patch; name=debug_extra_pci_bus_res.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fhi0rldq0
Content-Disposition: attachment; filename=debug_extra_pci_bus_res.patch

SW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9zZXR1cC1idXMuYwo9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBs
aW51eC0yLjYub3JpZy9kcml2ZXJzL3BjaS9zZXR1cC1idXMuYworKysgbGludXgtMi42L2RyaXZl
cnMvcGNpL3NldHVwLWJ1cy5jCkBAIC01MzcsNiArNTM3LDM2IEBAIHZvaWQgX19yZWYgcGNpX2J1
c19hc3NpZ25fcmVzb3VyY2VzKHN0cnUKIH0KIEVYUE9SVF9TWU1CT0wocGNpX2J1c19hc3NpZ25f
cmVzb3VyY2VzKTsKIAorc3RhdGljIHZvaWQgcGNpX2J1c19kdW1wX3JlcyhzdHJ1Y3QgcGNpX2J1
cyAqYnVzKQoreworICAgICAgICBpbnQgaTsKKworICAgICAgICBmb3IgKGkgPSAwOyBpIDwgUENJ
X0JVU19OVU1fUkVTT1VSQ0VTOyBpKyspIHsKKyAgICAgICAgICAgICAgICBzdHJ1Y3QgcmVzb3Vy
Y2UgKnJlcyA9IGJ1cy0+cmVzb3VyY2VbaV07CisgICAgICAgICAgICAgICAgaWYgKCFyZXMpCisg
ICAgICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsKKworCQlwcmludGsoS0VSTl9JTkZPICJi
dXM6ICUwMnggaW5kZXggJXggJXM6IFslbGx4LCAlbGx4XVxuIiwgYnVzLT5udW1iZXIsIGksIChy
ZXMtPmZsYWdzICYgSU9SRVNPVVJDRV9JTyk/ICJpbyBwb3J0IjoibW1pbyIsIHJlcy0+c3RhcnQs
IHJlcy0+ZW5kKTsKKyAgICAgICAgfQorfQorCitzdGF0aWMgdm9pZCBwY2lfYnVzX2R1bXBfcmVz
b3VyY2VzKHN0cnVjdCBwY2lfYnVzICpidXMpCit7CisJc3RydWN0IHBjaV9idXMgKmI7CisJc3Ry
dWN0IHBjaV9kZXYgKmRldjsKKworCisJcGNpX2J1c19kdW1wX3JlcyhidXMpOworCisJbGlzdF9m
b3JfZWFjaF9lbnRyeShkZXYsICZidXMtPmRldmljZXMsIGJ1c19saXN0KSB7CisJCWIgPSBkZXYt
PnN1Ym9yZGluYXRlOworCQlpZiAoIWIpCisJCQljb250aW51ZTsKKworCQlwY2lfYnVzX2R1bXBf
cmVzb3VyY2VzKGIpOworCX0KK30KKwogdm9pZCBfX2luaXQKIHBjaV9hc3NpZ25fdW5hc3NpZ25l
ZF9yZXNvdXJjZXModm9pZCkKIHsKQEAgLTU1Miw0ICs1ODIsOSBAQCBwY2lfYXNzaWduX3VuYXNz
aWduZWRfcmVzb3VyY2VzKHZvaWQpCiAJCXBjaV9idXNfYXNzaWduX3Jlc291cmNlcyhidXMpOwog
CQlwY2lfZW5hYmxlX2JyaWRnZXMoYnVzKTsKIAl9CisKKwkvKiBkdW1wIHRoZSByZXNvdXJjZSBv
biBidXNlcyAqLworCWxpc3RfZm9yX2VhY2hfZW50cnkoYnVzLCAmcGNpX3Jvb3RfYnVzZXMsIG5v
ZGUpIHsKKwkJcGNpX2J1c19kdW1wX3Jlc291cmNlcyhidXMpOworCX0KIH0K
------=_Part_10955_7710511.1213557522587
Content-Type: text/x-patch; name=debug_extra_pci_res_range.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fhi0sqob1
Content-Disposition: attachment; filename=debug_extra_pci_res_range.patch

SW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9wcm9iZS5jCj09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4
LTIuNi5vcmlnL2RyaXZlcnMvcGNpL3Byb2JlLmMKKysrIGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9w
cm9iZS5jCkBAIC0yNzUsNiArMjc1LDcgQEAgc3RhdGljIHZvaWQgcGNpX3JlYWRfYmFzZXMoc3Ry
dWN0IHBjaV9kZQogCQkJfQogCQkJcmVzLT5zdGFydCA9IGw2NCAmIFBDSV9CQVNFX0FERFJFU1Nf
TUVNX01BU0s7CiAJCQlyZXMtPmVuZCA9IHJlcy0+c3RhcnQgKyBzejY0OworCQkJcHJpbnRrKEtF
Uk5fSU5GTyAiUENJOiAlcyByZWcgJXggNjRiaXQgbW1pbzogWyVsbHgsICVsbHhdXG4iLCBwY2lf
bmFtZShkZXYpLCByZWcsIHJlcy0+c3RhcnQsIHJlcy0+ZW5kKTsKICNlbHNlCiAJCQlpZiAoc3o2
NCA+IDB4MTAwMDAwMDAwVUxMKSB7CiAJCQkJcHJpbnRrKEtFUk5fRVJSICJQQ0k6IFVuYWJsZSB0
byBoYW5kbGUgNjQtYml0ICIKQEAgLTI5MCw2ICsyOTEsOCBAQCBzdGF0aWMgdm9pZCBwY2lfcmVh
ZF9iYXNlcyhzdHJ1Y3QgcGNpX2RlCiAJCQkJcmVzLT5lbmQgPSBzejsKIAkJCX0KICNlbmRpZgor
CQl9IGVsc2UgeworCQkJcHJpbnRrKEtFUk5fSU5GTyAiUENJOiAlcyByZWcgJXggJXM6IFslbGx4
LCAlbGx4XVxuIiwgcGNpX25hbWUoZGV2KSwgcmVnLCAocmVzLT5mbGFncyAmIElPUkVTT1VSQ0Vf
SU8pPyAiaW8gcG9ydCI6IjMyYml0IG1taW8iLCByZXMtPnN0YXJ0LCByZXMtPmVuZCk7CiAJCX0K
IAl9CiAJaWYgKHJvbSkgewpAQCAtMzU3LDYgKzM2MCw3IEBAIHZvaWQgX19kZXZpbml0IHBjaV9y
ZWFkX2JyaWRnZV9iYXNlcyhzdHIKIAkJCXJlcy0+c3RhcnQgPSBiYXNlOwogCQlpZiAoIXJlcy0+
ZW5kKQogCQkJcmVzLT5lbmQgPSBsaW1pdCArIDB4ZmZmOworCQlwcmludGsoS0VSTl9JTkZPICJQ
Q0k6IGJyaWRnZSAlcyBpbyBwb3J0OiBbJWxseCwgJWxseF1cbiIsIHBjaV9uYW1lKGRldiksIHJl
cy0+c3RhcnQsIHJlcy0+ZW5kKTsKIAl9CiAKIAlyZXMgPSBjaGlsZC0+cmVzb3VyY2VbMV07CkBA
IC0zNjgsNiArMzcyLDcgQEAgdm9pZCBfX2RldmluaXQgcGNpX3JlYWRfYnJpZGdlX2Jhc2VzKHN0
cgogCQlyZXMtPmZsYWdzID0gKG1lbV9iYXNlX2xvICYgUENJX01FTU9SWV9SQU5HRV9UWVBFX01B
U0spIHwgSU9SRVNPVVJDRV9NRU07CiAJCXJlcy0+c3RhcnQgPSBiYXNlOwogCQlyZXMtPmVuZCA9
IGxpbWl0ICsgMHhmZmZmZjsKKwkJcHJpbnRrKEtFUk5fSU5GTyAiUENJOiBicmlkZ2UgJXMgMzJi
aXQgbW1pbzogWyVsbHgsICVsbHhdXG4iLCBwY2lfbmFtZShkZXYpLCByZXMtPnN0YXJ0LCByZXMt
PmVuZCk7CiAJfQogCiAJcmVzID0gY2hpbGQtPnJlc291cmNlWzJdOwpAQCAtNDAyLDYgKzQwNyw3
IEBAIHZvaWQgX19kZXZpbml0IHBjaV9yZWFkX2JyaWRnZV9iYXNlcyhzdHIKIAkJcmVzLT5mbGFn
cyA9IChtZW1fYmFzZV9sbyAmIFBDSV9NRU1PUllfUkFOR0VfVFlQRV9NQVNLKSB8IElPUkVTT1VS
Q0VfTUVNIHwgSU9SRVNPVVJDRV9QUkVGRVRDSDsKIAkJcmVzLT5zdGFydCA9IGJhc2U7CiAJCXJl
cy0+ZW5kID0gbGltaXQgKyAweGZmZmZmOworCQlwcmludGsoS0VSTl9JTkZPICJQQ0k6IGJyaWRn
ZSAlcyAlc2JpdCBtbWlvIHByZWY6IFslbGx4LCAlbGx4XVxuIiwgcGNpX25hbWUoZGV2KSwgKHJl
cy0+ZmxhZ3MgJiBQQ0lfUFJFRl9SQU5HRV9UWVBFXzY0KT8iNjQiOiIzMiIscmVzLT5zdGFydCwg
cmVzLT5lbmQpOwogCX0KIH0KIAo=
------=_Part_10955_7710511.1213557522587--

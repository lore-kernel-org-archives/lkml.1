Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbYIXTWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbYIXTWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYIXTWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:22:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:31411 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbYIXTWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=RFI7G44d1XH3UNzrveucX7qAgsR3v9pYQZN34Vh9/3LNRPOezNtdkkRoYyu8c7ozJh
         1SuQER8bD9a5Q94ufvmk71rUB/fVi+VW5iKRrWB7iOc2DYNIP1wK0kJKf71naw1UTqe4
         k5StqrmZtxkpuvbFv8hc5MwFQLxXe303//yL0=
Message-ID: <4807377b0809241222n4ebf4ca0ifc886e0436904121@mail.gmail.com>
Date: Wed, 24 Sep 2008 12:22:20 -0700
From: "Jesse Brandeburg" <jesse.brandeburg@gmail.com>
To: "Kyle McMartin" <kyle@mcmartin.ca>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Cc: "David Miller" <davem@davemloft.net>, airlied@gmail.com, jkosina@suse.cz,
       jeffrey.t.kirsher@intel.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
In-Reply-To: <20080924191022.GC2591@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_150566_25386232.1222284140146"
References: <alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz>
	 <20080923.211215.193696086.davem@davemloft.net>
	 <21d7e9970809232245x6a91c6e2l552ff039d07e2017@mail.gmail.com>
	 <20080924.003638.71148740.davem@davemloft.net>
	 <20080924191022.GC2591@phobos.i.cabal.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_150566_25386232.1222284140146
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Sep 24, 2008 at 12:10 PM, Kyle McMartin <kyle@mcmartin.ca> wrote:
> At the very least, if someone pokes in a hexdump of the firmware, at
> least we might be able to see some of the method to the madness of the
> corruption pattern.

Thanks Kyle!

attached is a patch to dump the eeprom to dmesg (first 64 bytes) at
boot for e1000e, which kind of goes along with your AWOOGA part of
your patch.

------=_Part_150566_25386232.1222284140146
Content-Type: text/plain; name=e1000e-dump-eeprom-to-dmesg.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flicdjrg0
Content-Disposition: attachment; filename=e1000e-dump-eeprom-to-dmesg.txt

ZTEwMDBlOiBkdW1wIGVlcHJvbSB0byBkbWVzZyBmb3IgaWNoOC85CgpGcm9tOiBKZXNzZSBCcmFu
ZGVidXJnIDxqZXNzZS5icmFuZGVidXJnQGludGVsLmNvbT4KCmR1bXBpbmcgdGhlIGVlcHJvbSBm
b3Igbm93IHNlZW1zIGxpa2UgYSBiaXQgb2YgYSB2ZXJib3NlCmhhY2ssIGJ1dCBtaWdodCBiZSB1
c2VmdWwgd2hlbiB3ZSB3YW50IHRvIHJlc3RvcmUgaXQuCgppZiBzeXNsb2dkIChvciBzb21ldGhp
bmcgbGlrZSkgaXNuJ3QgcnVubmluZyBpdCB3b24ndCBiZSBrZXB0Cmhvd2V2ZXIuCgpTaWduZWQt
b2ZmLWJ5OiBKZXNzZSBCcmFuZGVidXJnIDxqZXNzZS5icmFuZGVidXJnQGludGVsLmNvbT4KLS0t
CgogZHJpdmVycy9uZXQvZTEwMDBlL25ldGRldi5jIHwgICA1MSArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrCiAxIGZpbGVzIGNoYW5nZWQsIDUxIGluc2VydGlvbnMo
KyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZTEwMDBlL25ldGRl
di5jIGIvZHJpdmVycy9uZXQvZTEwMDBlL25ldGRldi5jCmluZGV4IDg5Y2EyNzIuLjQ4MDcyZmEg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L2UxMDAwZS9uZXRkZXYuYworKysgYi9kcml2ZXJzL25l
dC9lMTAwMGUvbmV0ZGV2LmMKQEAgLTQzMzgsNiArNDMzOCw1MiBAQCBzdGF0aWMgdm9pZCBlMTAw
MF9lZXByb21fY2hlY2tzKHN0cnVjdCBlMTAwMF9hZGFwdGVyICphZGFwdGVyKQogfQogCiAvKioK
KyAqIGUxMDAwZV9kdW1wX2VlcHJvbSAtIHdyaXRlIHRoZSBlZXByb20gdG8ga2VybmVsIGxvZwor
ICogQGFkYXB0ZXI6IG91ciBhZGFwdGVyIHN0cnVjdAorICoKKyAqIER1bXAgdGhlIGVlcHJvbSBm
b3IgdXNlcnMgaGF2aW5nIGNoZWNrc3VtIGlzc3VlcworICoqLworc3RhdGljIHZvaWQgZTEwMDBl
X2R1bXBfZWVwcm9tKHN0cnVjdCBlMTAwMF9hZGFwdGVyICphZGFwdGVyKQoreworCXN0cnVjdCBu
ZXRfZGV2aWNlICpuZXRkZXYgPSBhZGFwdGVyLT5uZXRkZXY7CisJc3RydWN0IGV0aHRvb2xfZWVw
cm9tIGVlcHJvbTsKKwljb25zdCBzdHJ1Y3QgZXRodG9vbF9vcHMgKm9wcyA9IG5ldGRldi0+ZXRo
dG9vbF9vcHM7CisJdTggKmRhdGE7CisJaW50IGk7CisJdTE2IGNzdW1fb2xkLCBjc3VtX25ldyA9
IDA7CisKKwllZXByb20ubGVuID0gb3BzLT5nZXRfZWVwcm9tX2xlbihuZXRkZXYpOworCWVlcHJv
bS5vZmZzZXQgPSAwOworCisJZGF0YSA9IGt6YWxsb2MoZWVwcm9tLmxlbiwgR0ZQX0tFUk5FTCk7
CisJaWYgKCFkYXRhKSB7CisJCXByaW50ayhLRVJOX0VSUiAiVW5hYmxlIHRvIGFsbG9jYXRlIG1l
bW9yeSB0byBkdW1wIEVFUFJPTSIKKwkJICAgICAgICIgZGF0YVxuIik7CisJCXJldHVybjsKKwl9
CisKKwlvcHMtPmdldF9lZXByb20obmV0ZGV2LCAmZWVwcm9tLCBkYXRhKTsKKworCWNzdW1fb2xk
ID0gKGRhdGFbTlZNX0NIRUNLU1VNX1JFRyAqIDJdKSArCisJCSAgIChkYXRhW05WTV9DSEVDS1NV
TV9SRUcgKiAyICsgMV0gPDwgOCk7CisJZm9yIChpID0gMDsgaSA8IE5WTV9DSEVDS1NVTV9SRUcg
KiAyOyBpICs9IDIpCisJCWNzdW1fbmV3ICs9IGRhdGFbaV0gKyAoZGF0YVtpICsgMV0gPDwgOCk7
CisJY3N1bV9uZXcgPSBOVk1fU1VNIC0gY3N1bV9uZXc7CisKKwlwcmludGsoS0VSTl9FUlIgIi8q
KioqKioqKioqKioqKioqKioqKiovXG4iKTsKKwlwcmludGsoS0VSTl9FUlIgIkN1cnJlbnQgRUVQ
Uk9NIENoZWNrc3VtIDogMHglMDR4XG4iLCBjc3VtX29sZCk7CisJcHJpbnRrKEtFUk5fRVJSICJD
YWxjdWxhdGVkICAgICAgICAgICAgICA6IDB4JTA0eFxuIiwgY3N1bV9uZXcpOworCisJcHJpbnRr
KEtFUk5fRVJSICJPZmZzZXQgICAgVmFsdWVzXG4iKTsKKwlwcmludGsoS0VSTl9FUlIgIj09PT09
PT09ICA9PT09PT1cbiIpOworCXByaW50X2hleF9kdW1wKEtFUk5fRVJSLCAiIiwgRFVNUF9QUkVG
SVhfT0ZGU0VULCAxNiwgMSwgZGF0YSwgMTI4LCAwKTsKKworCXByaW50ayhLRVJOX0VSUiAiLyoq
KioqKioqKioqKioqKioqKioqKi9cbiIpOworCisJa2ZyZWUoZGF0YSk7Cit9CisKKy8qKgogICog
ZTEwMDBfcHJvYmUgLSBEZXZpY2UgSW5pdGlhbGl6YXRpb24gUm91dGluZQogICogQHBkZXY6IFBD
SSBkZXZpY2UgaW5mb3JtYXRpb24gc3RydWN0CiAgKiBAZW50OiBlbnRyeSBpbiBlMTAwMF9wY2lf
dGJsCkBAIC00NTQxLDYgKzQ1ODcsMTEgQEAgc3RhdGljIGludCBfX2RldmluaXQgZTEwMDBfcHJv
YmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsCiAKIAllMTAwMF9lZXByb21fY2hlY2tzKGFkYXB0ZXIp
OwogCisJLyogZGVidWcgY29kZSAuLi4gZHVtcCB0aGUgZmlyc3QgMTI4IGJ5dGVzIG9mIHRoZSBl
ZXByb20gZm9yCisJICogaWNoIHBhcnRzIHRoYXQgbWlnaHQgZ2V0IGEgY29ycnVwdGlvbiAqLwor
CWlmIChhZGFwdGVyLT5mbGFncyAmIEZMQUdfSVNfSUNIKQorCQllMTAwMGVfZHVtcF9lZXByb20o
YWRhcHRlcik7CisKIAkvKiBjb3B5IHRoZSBNQUMgYWRkcmVzcyBvdXQgb2YgdGhlIE5WTSAqLwog
CWlmIChlMTAwMGVfcmVhZF9tYWNfYWRkcigmYWRhcHRlci0+aHcpKQogCQllX2VycigiTlZNIFJl
YWQgRXJyb3Igd2hpbGUgcmVhZGluZyBNQUMgYWRkcmVzc1xuIik7Cg==
------=_Part_150566_25386232.1222284140146--

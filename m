Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbYCHDSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbYCHDSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 22:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYCHDR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 22:17:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:30175 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbYCHDRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 22:17:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=yGkZSq89Qbqn8lixHB/Q2IXvZa5rB+aC+Qt1XRXww49ZzmYj5bb2TqFloYoiTjCSUII7qT0rmKqqpaVSvZNIfgNrGfqgtOEOTLE0ON1YoA7ki9ZARk53nGkNJ+FltylzMfjFXtwai6v+yAiBEnJUk3dDc1HIH3nc1HuDE7libUg=
Message-ID: <86802c440803071917s3e60ae97r201d1854972c97e8@mail.gmail.com>
Date: Fri, 7 Mar 2008 19:17:55 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86_64: sort address_markers for dump_pagetables
Cc: "kernel list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_28213_26352384.1204946275646"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_28213_26352384.1204946275646
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



------=_Part_28213_26352384.1204946275646
Content-Type: text/x-patch; name=x86_sort_dump_pagetables.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdjm7jk60
Content-Disposition: attachment; filename=x86_sort_dump_pagetables.patch

W1BBVENIXSB4ODZfNjQ6IHNvcnQgYWRkcmVzc19tYXJrZXJzIGZvciBkdW1wX3BhZ2V0YWJsZXMK
Cm90aGVyd2lzZSBWbWVtbWFwIGFuZCBIaWdoIEtlcm5lbCBNYXBwaW5nIHN0cmluZyBpcyBub3Qg
c2hvd2luZyB1cC4KClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlobHUua2VybmVsQGdtYWls
LmNvbT4KCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9tbS9kdW1wX3BhZ2V0YWJsZXMuYyBiL2FyY2gv
eDg2L21tL2R1bXBfcGFnZXRhYmxlcy5jCmluZGV4IDZkODQwMzMuLjY3OTFiODMgMTAwNjQ0Ci0t
LSBhL2FyY2gveDg2L21tL2R1bXBfcGFnZXRhYmxlcy5jCisrKyBiL2FyY2gveDg2L21tL2R1bXBf
cGFnZXRhYmxlcy5jCkBAIC00NCwxMCArNDQsMTAgQEAgc3RhdGljIHN0cnVjdCBhZGRyX21hcmtl
ciBhZGRyZXNzX21hcmtlcnNbXSA9IHsKIAl7IDB4ODAwMDAwMDAwMDAwMDAwMFVMLCAiS2VybmVs
IFNwYWNlIiB9LAogCXsgMHhmZmZmODEwMDAwMDAwMDAwVUwsICJMb3cgS2VybmVsIE1hcHBpbmci
IH0sCiAJeyBWTUFMTE9DX1NUQVJULCAgICAgICAgInZtYWxsb2MoKSBBcmVhIiB9LAotCXsgTU9E
VUxFU19WQUREUiwgICAgICAgICJNb2R1bGVzIiB9LAotCXsgTU9EVUxFU19FTkQsICAgICAgICAg
ICJFbmQgTW9kdWxlcyIgfSwKIAl7IFZNRU1NQVBfU1RBUlQsICAgICAgICAiVm1lbW1hcCIgfSwK
IAl7IF9fU1RBUlRfS0VSTkVMX21hcCwgICAiSGlnaCBLZXJuZWwgTWFwcGluZyIgfSwKKwl7IE1P
RFVMRVNfVkFERFIsICAgICAgICAiTW9kdWxlcyIgfSwKKwl7IE1PRFVMRVNfRU5ELCAgICAgICAg
ICAiRW5kIE1vZHVsZXMiIH0sCiAjZWxzZQogCXsgUEFHRV9PRkZTRVQsICAgICAgICAgICJLZXJu
ZWwgTWFwcGluZyIgfSwKIAl7IDAvKiBWTUFMTE9DX1NUQVJUICovLCAidm1hbGxvYygpIEFyZWEi
IH0sCg==
------=_Part_28213_26352384.1204946275646--

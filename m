Return-Path: <linux-kernel-owner+w=401wt.eu-S966193AbXDGRnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966193AbXDGRnV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933630AbXDGRnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:43:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:59466 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933617AbXDGRnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=HITIonuCoD37W2o8tIHwaUTvrZea+E1q4wJtGn+TJSN5kJOwV+iJ48FlE4j6/CLmyFBW+iOVWF0SU1Wk8mphAMwrJF/REtb+NWGOhKmhblHqLcdnzpKrIb/d7TX5NwGYbZmvVZo7szFIlE+wkujXQN4o2BXm0iGFjncKptrDdSU=
Message-ID: <8d158e1f0704071043w5483f60ayc9f240abb1039392@mail.gmail.com>
Date: Sat, 7 Apr 2007 19:43:16 +0200
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, netfilter@lists.netfilter.org
Subject: [PATCH] ip_tables.h
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_6821_31053376.1175967796823"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_6821_31053376.1175967796823
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi lads,

I had some problems compiling the external netfilter modules due to
missing definitions.
I googled a lot, saw a lot of people having the same problems but no
real answer to how to fix it.

So.. I made a little patch which make things work for me, at least.

Modules that work after applying the patch are the geopip module,
connlimit module, and prolly more, but I didnt test them.

Please note, I am not a coder, not a maintainer and I am happy that I
didnt break anything so please don't consider this as a proposal to
include in the kernel or something, I am just in favor of sharing what
helped me getting things to work, if i can help others with it or if
it is interesting material for inclusion, even better :)

So, the patch is attached in this email and can also be found on
http://www.patrickale.eu/documents/archives/patches/ip_tables.h.diff


I hope this helps a people or two.


Patrick

------=_Part_6821_31053376.1175967796823
Content-Type: text/x-patch; name="ip_tables.h.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="ip_tables.h.diff"
X-Attachment-Id: f_f08f4o42

LS0tIGluY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjQvaXBfdGFibGVzLmgub3JpZyAgICAgICAy
MDA3LTA0LTA3IDIwOjMwOjI1LjM0NDM2NTcwNyArMDIwMAorKysgaW5jbHVkZS9saW51eC9uZXRm
aWx0ZXJfaXB2NC9pcF90YWJsZXMuaCAgICAyMDA3LTA0LTA3IDIwOjM0OjA1LjA3Njg4NzU1MCAr
MDIwMApAQCAtMzQsNiArMzQsMTIgQEAKICNkZWZpbmUgaXB0X3RhYmxlIHh0X3RhYmxlCiAjZGVm
aW5lIGlwdF9nZXRfcmV2aXNpb24geHRfZ2V0X3JldmlzaW9uCgorI2RlZmluZSBpcHRfcmVnaXN0
ZXJfbWF0Y2gobXRjaCkgICAgICAgIFwKKyh7ICAgICAgKG10Y2gpLT5mYW1pbHkgPSBBRl9JTkVU
OyAgICAgICBcCisgICAgICAgIHh0X3JlZ2lzdGVyX21hdGNoKG10Y2gpOyB9KQorI2RlZmluZSBp
cHRfdW5yZWdpc3Rlcl9tYXRjaChtdGNoKSB4dF91bnJlZ2lzdGVyX21hdGNoKG10Y2gpCisKKwog
LyogWWVzLCBWaXJnaW5pYSwgeW91IGhhdmUgdG8gemVybyB0aGUgcGFkZGluZy4gKi8KIHN0cnVj
dCBpcHRfaXAgewogICAgICAgIC8qIFNvdXJjZSBhbmQgZGVzdGluYXRpb24gSVAgYWRkciAqLwoK

------=_Part_6821_31053376.1175967796823--

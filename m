Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbYJXMCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbYJXMCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 08:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYJXMBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 08:01:52 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:62124 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYJXMBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 08:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=WiYpzuZikbvwzBEIwJ/Yd3i/0lfpXxlUsc4cqrqUary+XEAHgAbugtnqy8el8yRlco
         +WqOdJ7JfZvVlBWrgh7pLzj4qgXiMAenHUYqOdgQ1UK4aKhKnmp5t6C5MjJezgz3dsq0
         pqrX0gG3tbgrsS797RgHu31i9FKQ8hhL55Bmo=
Message-ID: <5787cf470810240501j3522e8c8ld9a8498ff1bfef21@mail.gmail.com>
Date: Fri, 24 Oct 2008 14:01:48 +0200
From: "Uros Bizjak" <ubizjak@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH, x86]: Implement change_bit with immediate operand as "lock xorb"
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_4207_8707328.1224849708262"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_4207_8707328.1224849708262
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello!

Implement change_bit with immediate bit count as "lock xorb". This is
similar to  "lock orb" and "lock andb"  for set_bit and clear_bit
functions.

Uros.

------=_Part_4207_8707328.1224849708262
Content-Type: text/plain; name=bitops.diff.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fmortg1k0
Content-Disposition: attachment; filename=bitops.diff.txt

LS0tIGJpdG9wcy5ofgkyMDA4LTEwLTIyIDIzOjM4OjAxLjAwMDAwMDAwMCArMDIwMAorKysgYml0
b3BzLmgJMjAwOC0xMC0yNCAxMjo1NzoxNC4wMDAwMDAwMDAgKzAyMDAKQEAgLTE2OCw3ICsxNjgs
MTUgQEAKICAqLwogc3RhdGljIGlubGluZSB2b2lkIGNoYW5nZV9iaXQoaW50IG5yLCB2b2xhdGls
ZSB1bnNpZ25lZCBsb25nICphZGRyKQogewotCWFzbSB2b2xhdGlsZShMT0NLX1BSRUZJWCAiYnRj
ICUxLCUwIiA6IEFERFIgOiAiSXIiIChucikpOworCWlmIChJU19JTU1FRElBVEUobnIpKSB7CisJ
CWFzbSB2b2xhdGlsZShMT0NLX1BSRUZJWCAieG9yYiAlMSwlMCIKKwkJCTogQ09OU1RfTUFTS19B
RERSKG5yLCBhZGRyKQorCQkJOiAiaXEiICgodTgpQ09OU1RfTUFTSyhucikpKTsKKwl9IGVsc2Ug
eworCQlhc20gdm9sYXRpbGUoTE9DS19QUkVGSVggImJ0YyAlMSwlMCIKKwkJCTogQklUT1BfQURE
UihhZGRyKQorCQkJOiAiSXIiIChucikpOworCX0KIH0KIAogLyoqCg==
------=_Part_4207_8707328.1224849708262--

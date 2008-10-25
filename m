Return-Path: <linux-kernel-owner+w=401wt.eu-S1753006AbYJYJ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbYJYJ1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 05:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYJYJ1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 05:27:01 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:42966 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbYJYJ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 05:27:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=kJ8/3UotQfJOflV8VOA6pjKF28k0hulyfsA5dOsVeMG5C5d7uPp2l9SwAxTyclaqYJ
         f4zZhrTMCdUMmhNfxMyIjFiDmJjhR+Jo2VfSH61nCWkpnMsDOm3NGhic/vAVghIxqBjf
         yuoDtX6rVNN+Q5vBaiERM+8SCrvaa6P2OluEo=
Message-ID: <5787cf470810250226s2ce4bf11o3860506c3a049f3f@mail.gmail.com>
Date: Sat, 25 Oct 2008 11:26:59 +0200
From: "Uros Bizjak" <ubizjak@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH, x86]: Implement change_bit with immediate operand as "lock xorb"
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <5787cf470810240753wdf1fd9co14dbd25ae6ff439c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_11829_25211101.1224926819639"
References: <5787cf470810240501j3522e8c8ld9a8498ff1bfef21@mail.gmail.com>
	 <5787cf470810240753wdf1fd9co14dbd25ae6ff439c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_11829_25211101.1224926819639
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Oct 24, 2008 at 2:01 PM, Uros Bizjak <ubizjak@gmail.com> wrote:

> Implement change_bit with immediate bit count as "lock xorb". This is
> similar to  "lock orb" and "lock andb"  for set_bit and clear_bit
> functions.

Forgot Signed-off-by line and added CC.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>

Uros.

------=_Part_11829_25211101.1224926819639
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
------=_Part_11829_25211101.1224926819639--

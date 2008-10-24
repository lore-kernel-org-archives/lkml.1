Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbYJXOxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbYJXOxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbYJXOxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:53:36 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:49302 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbYJXOxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:references;
        b=prsTkbFD7SiKVginaxGhFbGckfrJTupv1uqMxAwZ/5kLIxsAqxBoE/YldaarIEv2Dc
         lrZLYQhs0bQ7HbC2IX2wH5hMv2JZg37Mx4DvTr3qz6eJZsVhqZfwcvncAkDnMtCq/rQn
         wAkGw8pzwPdsK0+lzT8x9j7g9PTc1kAH0GF/I=
Message-ID: <5787cf470810240753wdf1fd9co14dbd25ae6ff439c@mail.gmail.com>
Date: Fri, 24 Oct 2008 16:53:33 +0200
From: "Uros Bizjak" <ubizjak@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, x86]: Implement change_bit with immediate operand as "lock xorb"
In-Reply-To: <5787cf470810240501j3522e8c8ld9a8498ff1bfef21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_5481_12241287.1224860013453"
References: <5787cf470810240501j3522e8c8ld9a8498ff1bfef21@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_5481_12241287.1224860013453
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Oct 24, 2008 at 2:01 PM, Uros Bizjak <ubizjak@gmail.com> wrote:

> Implement change_bit with immediate bit count as "lock xorb". This is
> similar to  "lock orb" and "lock andb"  for set_bit and clear_bit
> functions.

Forgot Signed-off-by line.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>

Uros.

------=_Part_5481_12241287.1224860013453
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
------=_Part_5481_12241287.1224860013453--

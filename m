Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbZAVHeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbZAVHeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 02:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbZAVHeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 02:34:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:58188 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbZAVHd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 02:33:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=RQZXB++gwg4tMpc+g53xRBM34ONqhC3RtK7V0fiVMHlD8osIx5ks6544S81BhnN5lE
         jdtucrSYpzHtZlvB+qdDhaHZdjgVCLlUJucLwVtYP7sSq1aY/MOQBsqkeze4YpTmCWga
         wNisKNt3YsgdXmjp2oR+I30nqEwsRAyjphyJM=
MIME-Version: 1.0
Date: Thu, 22 Jan 2009 08:33:57 +0100
Message-ID: <5787cf470901212333m749085ebjda40e869ab4bdffc@mail.gmail.com>
Subject: [patch] x86: Unneeded assignment to tsk in recent x86 change, v2
From: Uros Bizjak <ubizjak@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6d3766193feca04610d4b35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d3766193feca04610d4b35
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Wed, Jan 21, 2009 at 10:13 PM, Mikael Pettersson <mikpe@it.uu.se> wrote:

Impact: Cleanup.

Remove unneeded assignment to tsk in recent x86 change.

>  > Hm, I'm not sure I see the inconsistency here. Care to explain this
>  > inconsistency in a couple of words?
>
> You're initialising some variables in their declarations, and some
> using assignments at the start of the procedure body. In particular,
> for some reason you don't initialise 'mm' in its declaration even
> though you could do so for consistency with 'tsk'.
>
> However, I'm strongly in favour of separating declarations and
> initialisations (esp. ones that need actual computations), so
> rather than subjecting 'mm' to the treatment you gave 'tsk',
> just leave the code alone.
>

Patch v2 with the second hunk removed is attached to this message.

Thanks,
Uros.

--0016e6d3766193feca04610d4b35
Content-Type: text/plain; charset=US-ASCII; name="p.diff.txt"
Content-Disposition: attachment; filename="p.diff.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fq93xja00

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL2ZhdWx0LmMgYi9hcmNoL3g4Ni9tbS9mYXVsdC5jCmlu
ZGV4IDkzYTU2M2IuLjYyMWU5YjMgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L21tL2ZhdWx0LmMKKysr
IGIvYXJjaC94ODYvbW0vZmF1bHQuYwpAQCAtNDIxLDcgKzQyMSw2IEBAIHN0YXRpYyBub2lubGlu
ZSB2b2lkIHBndGFibGVfYmFkKHN0cnVjdCBwdF9yZWdzICpyZWdzLAogCXByaW50ayhLRVJOX0FM
RVJUICIlczogQ29ycnVwdGVkIHBhZ2UgdGFibGUgYXQgYWRkcmVzcyAlbHhcbiIsCiAJICAgICAg
IHRzay0+Y29tbSwgYWRkcmVzcyk7CiAJZHVtcF9wYWdldGFibGUoYWRkcmVzcyk7Ci0JdHNrID0g
Y3VycmVudDsKIAl0c2stPnRocmVhZC5jcjIgPSBhZGRyZXNzOwogCXRzay0+dGhyZWFkLnRyYXBf
bm8gPSAxNDsKIAl0c2stPnRocmVhZC5lcnJvcl9jb2RlID0gZXJyb3JfY29kZTsK
--0016e6d3766193feca04610d4b35--

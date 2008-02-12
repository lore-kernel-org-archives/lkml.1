Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbYBLTVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbYBLTVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYBLTV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:21:26 -0500
Received: from smtp-out.google.com ([216.239.45.13]:21246 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbYBLTVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:21:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:in-reply-to:
	mime-version:content-type:references;
	b=ns88+6NfY+rhquUU6LMOizwnl6/+WOKaHXAa2mmFS5RZKV6kjiCuG9nvJ5DUy1KX1
	gI9Lp3yYCU9Q7IaOVZHGg==
Message-ID: <3f1a065b0802121121s3a04c264xfd6f1311272588fc@mail.gmail.com>
Date: Tue, 12 Feb 2008 11:21:12 -0800
From: "Russell Leidich" <rml@google.com>
To: "Andi Kleen" <andi@firstfloor.org>,
       "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>, valdis.kletnieks@vt.edu
Subject: Re: [PATCH] Remove Barcelona Thermal Throttling
In-Reply-To: <3f1a065b0802041122t6cec1803r89cdcd380fb3b5c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_35702_26132082.1202844072603"
References: <3f1a065b0802032213j713fe551t9a0642ea2b83994@mail.gmail.com>
	 <20080204072013.GB571@one.firstfloor.org>
	 <3f1a065b0802041122t6cec1803r89cdcd380fb3b5c0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_35702_26132082.1202844072603
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

All,

Sorry this took so long.  I have attached the Kconfig changes
requested by Andi, appended to the original patch.

On Feb 4, 2008 11:22 AM, Russell Leidich <rml@google.com> wrote:
> On Feb 3, 2008 11:20 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > On Sun, Feb 03, 2008 at 10:13:53PM -0800, Russell Leidich wrote:
> > > All,
> > >
> > > You can imagine my dismay when I recently learned that, after all our
> > > collective effort, hardware thermal throttling does not work reliably
> > > on Barcelona, according to AMD.  Due to NDA restrictions, I am unable
> > > to provide further details.
> >
> > Too bad. Hopefully that code will work then on the hypothetic
> > future parts with fixed throttling. Perhaps it would be better
> > to just remove it now and readd later.
>
> I really think it's best to leave it in.  It's harmless at the moment,
> and readding it later will just create a massive amount of duplicate
> work.    Sooner or later, I'm have little doubt that AMD can make this
> feature work.
>
> >
> > All this reminds me you need to adjust the Kconfig dependencies
> > for K8_NB too to be always enabled with MCE_AMD.
> >
> > Ideally on top of this patch with a || MCE_AMD
>
> OK, if you'll take the patch, I'd be happy to do this :).  I'm
> assuming that you mean I should force K8_NB = "yes" if MCE_AMD = "yes"
> in .config.  Is that what you're asking for?
>
> >
> > -Andi

-- 
Russell Leidich

------=_Part_35702_26132082.1202844072603
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fckuafjq0
Content-Disposition: attachment; filename=patch.txt

U2lnbmVkLW9mZi1ieTogUnVzc2VsbCBMZWlkaWNoIDxybWxAZ29vZ2xlLmNvbT4KLS0tIGxpbnV4
LTIuNi4yNC1yYzUub3JpZy9hcmNoL3g4Ni9rZXJuZWwvY3B1L21jaGVjay9tY2VfYW1kXzY0LmMJ
MjAwOC0wMi0wMyAyMToxNzo1OC4xODY2MTMwMDAgLTA4MDAKKysrIGxpbnV4LTIuNi4yNC1yYzUv
YXJjaC94ODYva2VybmVsL2NwdS9tY2hlY2svbWNlX2FtZF82NC5jCTIwMDgtMDItMDMgMjE6NTE6
MzguODEwOTg5MDAwIC0wODAwCkBAIC03NDIsMTMgKzc0MiwyMCBAQCBzdGF0aWMgdm9pZCBzbXBf
dGhlcm1hbF9ub3J0aGJyaWRnZV9pbml0CiAJCSAqLwogCQlwY2lfcmVhZF9jb25maWdfZHdvcmQo
azhfbm9ydGhicmlkZ2VzW25iX251bV0sCiAJCQkJCVRIRVJNX0NUTF9GM1g2NCwgJnRoZXJtX2N0
bF9mM3g2NCk7Ci0JCXRoZXJtX2N0bF9mM3g2NCB8PSBQU0xfQVBJQ19ISV9FTiB8IEhUQ19FTjsK
KwkJdGhlcm1fY3RsX2YzeDY0IHw9IFBTTF9BUElDX0hJX0VOOwogCQl0aGVybV9jdGxfZjN4NjQg
Jj0gKH5QU0xfQVBJQ19MT19FTik7CiAJCXBjaV93cml0ZV9jb25maWdfZHdvcmQoazhfbm9ydGhi
cmlkZ2VzW25iX251bV0sCiAJCQkJCVRIRVJNX0NUTF9GM1g2NCwgdGhlcm1fY3RsX2YzeDY0KTsK
LQkJcHJpbnRrKEtFUk5fSU5GTyAiQ1BVIHRoZXJtYWwgdGhyb3R0bGluZyBpbnRlcnJ1cHRzIGVu
YWJsZWQgaW4gIgotCQkJIlBDSSBidXMgMHgwLCBkZXZpY2UgMHgleCwgZnVuY3Rpb24gMHgzLCBy
ZWdpc3RlciAweDY0LiIKLQkJCSJcbiIsIGs4X25vcnRoYnJpZGdlc1tuYl9udW1dLT5kZXZmbiA+
PiAzKTsKKwkJaWYgKHRoZXJtX2N0bF9mM3g2NCAmIEhUQ19FTikKKwkJCXByaW50ayhLRVJOX0lO
Rk8gIkNQVSB0aGVybWFsIHRocm90dGxpbmcgaW50ZXJydXB0cyAiCisJCQkJImVuYWJsZWQgaW4g
UENJIGJ1cyAweDAsIGRldmljZSAweCV4LCBmdW5jdGlvbiAiCisJCQkJIjB4MywgcmVnaXN0ZXIg
MHg2NC5cbiIsCisJCQkJUENJX1NMT1Qoazhfbm9ydGhicmlkZ2VzW25iX251bV0tPmRldmZuKSk7
CisJCWVsc2UKKwkJCXByaW50ayhLRVJOX1dBUk5JTkcgIkNQVSB0aGVybWFsIHRocm90dGxpbmcg
ZGlzYWJsZWQgYnkiCisJCQkJIiB0aGUgQklPUyBpbiBQQ0kgYnVzIDB4MCwgZGV2aWNlIDB4JXgs
ICIKKwkJCQkiZnVuY3Rpb24gMHgzLCByZWdpc3RlciAweDY0LCBiaXQgMHgwLlxuIiwKKwkJCQlQ
Q0lfU0xPVChrOF9ub3J0aGJyaWRnZXNbbmJfbnVtXS0+ZGV2Zm4pKTsKIAl9CiB9CiAKQEAgLTgz
NSw3ICs4NDIsNyBAQCBzdGF0aWMgdm9pZCBzbXBfdGhlcm1hbF9lYXJseV90aHJvdHRsZV9jCiAg
KiBjb3JyZXNwb25kaW5nIEFQSUMgaW5pdGlhbGl6YXRpb24gb24gZWFjaCBjb3JlLgogICoKICAq
IER1ZSB0byBhbiBlcnJhdHVtIGludm9sdmluZyB0aGUgdGhlcm1hbCBzZW5zb3IsIHRoaXMgY29k
ZSBkb2VzIG5vdCB3b3JrIG9uCi0gKiBhbnkgQ1BVIHByaW9yIHRvIEZhbWlseSAweDEwLgorICog
Q1BVcyB3aXRoIGNlcnRhaW4gbm9ydGhicmlkZ2UgZGV2aWNlIElEcywgYXMgY29kZWQgYmVsb3cu
CiAgKi8KIHN0YXRpYyBpbnQgc21wX3RoZXJtYWxfaW50ZXJydXB0X2luaXQodm9pZCkKIHsKQEAg
LTg0NCwxMyArODUxLDE1IEBAIHN0YXRpYyBpbnQgc21wX3RoZXJtYWxfaW50ZXJydXB0X2luaXQo
dm8KIAlpZiAobnVtX2s4X25vcnRoYnJpZGdlcyA9PSAwKQogCQlnb3RvIG91dDsKIAkvKgotCSAq
IElmIGFueSBvZiB0aGUgbm9ydGhicmlkZ2VzIGhhcyBQQ0kgSUQgMHgxMTAzLCB0aGVuIGl0cyB0
aGVybWFsCi0JICogaGFyZHdhcmUgc3VmZmVycyBmcm9tIGFuIGVycmF0dW0gd2hpY2ggcHJldmVu
dHMgdGhpcyBjb2RlIGZyb20KLQkgKiB3b3JraW5nLCBzbyBhYm9ydC4gIChUaGlzIGltcGxpZXMg
dGhhdCBpdCBvbmx5IHdvcmtzIG9uIEZhbWlseQotCSAqIDB4MTAuKQorCSAqIElmIGFueSBvZiB0
aGUgbm9ydGhicmlkZ2VzIGhhcyBhbnkgb2YgdGhlIGRldmljZSBJRHMgaW4gdGhlIGZvbGxvd2lu
ZworCSAqIGxvb3AsIHRoZW4gdGhlIGhhcmR3YXJlIHN1ZmZlcnMgZnJvbSBhbiBlcnJhdHVtIHdo
aWNoIHByZXZlbnRzCisJICogdGhpcyBjb2RlIGZyb20gd29ya2luZywgc28gYWJvcnQuCiAJICov
CiAJZm9yIChuYl9udW0gPSAwOyBuYl9udW0gPCBudW1fazhfbm9ydGhicmlkZ2VzOyBuYl9udW0r
KykgewotCQlpZiAoKGs4X25vcnRoYnJpZGdlc1tuYl9udW1dLT5kZXZpY2UpID09IDB4MTEwMykK
KwkJX191MzIgZGV2aWNlX2lkOworCisJCWRldmljZV9pZCA9IGs4X25vcnRoYnJpZGdlc1tuYl9u
dW1dLT5kZXZpY2U7CisJCWlmICgoZGV2aWNlX2lkID09IDB4MTEwMykgfHwgKGRldmljZV9pZCA9
PSAweDEyMDMpKQogCQkJZ290byBvdXQ7CiAJfQogCS8qCi0tLSBsaW51eC0yLjYuMjQtcmM1Lm9y
aWcvYXJjaC94ODYvS2NvbmZpZwkyMDA3LTEyLTExIDE0OjMwOjUyLjcwODk4MzAwMCAtMDgwMAor
KysgbGludXgtMi42LjI0LXJjNS9hcmNoL3g4Ni9LY29uZmlnCTIwMDgtMDItMTIgMTE6MDE6MjQu
ODYwMTIzMDAwIC0wODAwCkBAIC01NjQsNiArNTY0LDcgQEAgY29uZmlnIFg4Nl9NQ0VfSU5URUwK
IGNvbmZpZyBYODZfTUNFX0FNRAogCWJvb2wgIkFNRCBNQ0UgZmVhdHVyZXMiCiAJZGVwZW5kcyBv
biBYODZfNjQgJiYgWDg2X01DRSAmJiBYODZfTE9DQUxfQVBJQworCXNlbGVjdCBLOF9OQgogCWRl
ZmF1bHQgeQogCWhlbHAKIAkgICBBZGRpdGlvbmFsIHN1cHBvcnQgZm9yIEFNRCBzcGVjaWZpYyBN
Q0UgZmVhdHVyZXMgc3VjaCBhcwpAQCAtMTU1OSw4ICsxNTYwLDcgQEAgZW5kaWYgIyBYODZfMzIK
IAogY29uZmlnIEs4X05CCiAJZGVmX2Jvb2wgeQotCWRlcGVuZHMgb24gQUdQX0FNRDY0IHx8IChY
ODZfNjQgJiYgKEdBUlRfSU9NTVUgfHwgKFBDSSAmJiBOVU1BKSkpCi0KKwlkZXBlbmRzIG9uIEFH
UF9BTUQ2NCB8fCAoWDg2XzY0ICYmIChHQVJUX0lPTU1VIHx8IChQQ0kgJiYgTlVNQSkpKSB8fCBY
ODZfTUNFX0FNRAogc291cmNlICJkcml2ZXJzL3BjbWNpYS9LY29uZmlnIgogCiBzb3VyY2UgImRy
aXZlcnMvcGNpL2hvdHBsdWcvS2NvbmZpZyIK
------=_Part_35702_26132082.1202844072603--

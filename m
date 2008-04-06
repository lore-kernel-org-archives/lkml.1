Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbYDFI1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbYDFI1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 04:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYDFI07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 04:26:59 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:27438 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYDFI04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 04:26:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=S5akIZB2ZLiiAGcirhA/781uA82/9ewjG3nvA5tV1HuxpGW1YywtrSTIipL4ktmHFbDY7/Ekl2J9etOAh1X/wyIwAN7F/HAQMR3GF7Rv5vLgNwya4pgo9sA6Adr6H0JgXgCZSsJT4f1aXUnUsRmt8CJp+JQ/Dv5u4REiHaeu4Tk=
Message-ID: <86802c440804060126le714cfcj3772b82c67f92659@mail.gmail.com>
Date: Sun, 6 Apr 2008 01:26:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Zhao Yakui" <yakui.zhao@intel.com>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: + acpi-fix-bug-10124.patch added to -mm tree
Cc: "Greg KH" <greg@kroah.com>, lenb@kernel.org, stian@jordet.net,
       "Linux Kernel ML" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440804060026o43507775icb4456c0a9f86e07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_9453_17473451.1207470413923"
References: <200804032127.m33LRHxl023552@imap1.linux-foundation.org>
	 <20080403233701.GA13357@kroah.com>
	 <20080403170009.baa2b446.akpm@linux-foundation.org>
	 <1207492303.13675.4.camel@yakui_zhao.sh.intel.com>
	 <86802c440804060026o43507775icb4456c0a9f86e07@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_9453_17473451.1207470413923
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Apr 6, 2008 at 12:26 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> On Sun, Apr 6, 2008 at 7:31 AM, Zhao Yakui <yakui.zhao@intel.com> wrote:
>  > On Thu, 2008-04-03 at 17:00 -0700, Andrew Morton wrote:
>  >  > On Thu, 3 Apr 2008 16:37:01 -0700 Greg KH <greg@kroah.com> wrote:
>  >
>  > >
>  >  > > On Thu, Apr 03, 2008 at 02:27:17PM -0700, akpm@linux-foundation.org wrote:
>  >  > > >
>  >  > > > The patch titled
>  >  > > >      acpi: fix bug 10124
>  >  > > > has been added to the -mm tree.  Its filename is
>  >  > > >      acpi-fix-bug-10124.patch
>  >  > > >
>  >  > > > Before you just go and hit "reply", please:
>  >  > > >    a) Consider who else should be cc'ed
>  >  > > >    b) Prefer to cc a suitable mailing list as well
>  >  > > >    c) Ideally: find the original patch on the mailing list and do a
>  >  > > >       reply-to-all to that, adding suitable additional cc's
>  >  > > >
>  >  > > > *** Remember to use Documentation/SubmitChecklist when testing your code ***
>  >  > > >
>  >  > > > See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
>  >  > > > out what to do about this
>  >  > > >
>  >  > > > The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
>  >  > > >
>  >  > > > ------------------------------------------------------
>  >  > > > Subject: acpi: fix bug 10124
>  >  > > >
>  >  > > >
>  >  > > > Unchangelogged patch, taken from
>  >  > > > http://bugzilla.kernel.org/show_bug.cgi?id=10124
>  >  > > >
>  >  > > > Cc: <yakui.zhao@intel.com>
>  >  > > > Cc: Stian Jordet <stian@jordet.net>
>  >  > > > Cc: Len Brown <lenb@kernel.org>
>  >  > > > Cc: Greg KH <greg@kroah.com>
>  >  > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>  >  > >
>  >  > > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
>  >  > >
>  >  > > This should go through Len to Linus for 2.6.25.
>  >  > >
>  >  >
>  >  > That patch was written over a month ago!  Something is wrong here.
>  >  >
>  >  > Could someone please write a changelog for it asap?  Then if there's no
>  >  > fur
>  >  The patch is out of date. Yinghai Lu sent the updated patch on March
>  >  4th. But the patch is not merged into the git tree.
>  >  I will  refresh the patch from the Yinghai Lu and send it again.
>  >  Thanks.
>  >  > ther movement I'll merge it this weekend.
>  >  >
>
>  Ingo,
>
>  A: - in x86.git/latest
>  commit 3dab95bd91b6061a887b8a199261c1d92074da85
>  Author: Yinghai Lu <yhlu.kernel@gmail.com>
>  Date:   Tue Mar 4 11:34:23 2008 -0800
>
>     ACPI: Unneccessary to scan the PCI bus already scanned.
>
>
>     http://bugzilla.kernel.org/show_bug.cgi?id=10124
>
>  is the one Yakui mentioned, but it is after
>
>  B: - in x86.git/latest
>  commit e5491e8eb56d2e4bb0e4a6795bf0662c6703d5ac
>  Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
>  Date:   Tue Feb 19 03:20:09 2008 -0800
>
>     x86: get mp_bus_to_node early
>
>  C: - in x86.git/latest
>  commit c0f03f8c4c8dc0aa5fb5d0b791e76f6dff84a288
>  Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
>  Date:   Wed Feb 20 12:41:52 2008 -0800
>
>     x86/acpi: make dev_to_node return online node
>
>  if the A kind patch is merged to Linus tree via Andrew, we may need
>  update B and C. to make sure pci/acpi.c is same between
>  B+C+A with new A + new B + new C

Andrew,

please use following for changelog

-------------------
    ACPI: Unneccessary to scan the PCI bus already scanned.

    http://bugzilla.kernel.org/show_bug.cgi?id=10124

    this change:

      commit 08f1c192c3c32797068bfe97738babb3295bbf42
      Author: Muli Ben-Yehuda <muli@il.ibm.com>
      Date:   Sun Jul 22 00:23:39 2007 +0300

         x86-64: introduce struct pci_sysdata to facilitate sharing of ->sysdata

         This patch introduces struct pci_sysdata to x86 and x86-64, and
         converts the existing two users (NUMA, Calgary) to use it.

         This lays the groundwork for having other users of sysdata, such as
         the PCI domains work.

         The Calgary bits are tested, the NUMA bits just look ok.

    replaces pcibios_scan_root by pci_scan_bus_parented...

    but in pcibios_scan_root we have a check about scanned busses.
---------------------


Ingo,

when new A is merged, please use attached as new B. and C seem ok...


YH

------=_Part_9453_17473451.1207470413923
Content-Type: text/x-patch; name=get_mp_bus_early_v3.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fepcsxtd0
Content-Disposition: attachment; filename=get_mp_bus_early_v3.patch

eDg2OiBnZXQgbXBfYnVzX3RvX25vZGUgZWFybHkgdjMKCmN1cnJlbnQgb24gYW1kIGs4IHN5c3Rl
bSB3aXRoIG11bHRpIGh0IGNoYWluLCB0aGUgbnVtYV9ub2RlIG9mIHBjaSBkZXZpY2VzIHVuZGVy
Ci9zeXMvZGV2aWNlcy9wY2kwMDAwOjgwLyogYWx3YXlzIDAsIGV2ZW4gdGhhdCBjaGFpbiBpcyBv
biBub2RlIDEgb3IgMiBvciAzLgoKd29ya2Fyb3VuZDogcGNpYnVzX3RvX25vZGUoYnVzKSBpcyB1
c2VkIHdoZW4gd2Ugd2FudCB0byBnZXQgbm9kZSB0aGF0IHBjaV9kZXZpY2UgaXMgb24uCgpJbiBz
dHJ1Y3QgZGV2aWNlLCB3ZSBhbHJlYWR5IGhhdmUgbnVtYV9ub2RlIG1lbWJlci4gYW5kIHdlIGNv
dWxkIHVzZSBkZXZfdG9fbm9kZSgpCi9zZXRfZGV2X25vZGUoKSB0byBnZXQgYW5kIHNldCBudW1h
X25vZGUgaW4gdGhlIGRldmljZS4Kc2V0X2Rldl9ub2RlIGlzIGNhbGxlZCBpbiBwY2lfZGV2aWNl
X2FkZCgpIHdpdGggcGNpYnVzX3RvX25vZGUoYnVzKS4gYW5kCnBjaWJ1c190b19ub2RlIHVzZSBi
dXMtPnN5c2RhdGEgZm9yIG5vZGVpZC4KCnRoZSBwcm9ibGVtIGlzIHdoZW4gcGNpX2FkZF9kZXZp
Y2UgaXMgY2FsbGVkLCBidXMtPnN5c2RhdGEgaXMgbm90IGFzc2lnbmVkCmNvcnJlY3Qgbm9kZWlk
IHlldC4gdGhlIHJlc3VsdCB3aWxsIGJlIG51bWFfbm9kZSBhbHdheXMgaXMgMC4KCnBjaWJpb3Nf
c2Nhbl9yb290IGFuZCBwY2lfc2Nhbl9yb290IGNvdWxkIHRha2Ugc3lzZGF0YS4gU28gd2UgbmVl
ZCB0byBnZXQKbXBfYnVzX3RvX25vZGUgbWFwcGluZyBiZWZvcmUgdGhlc2UgdHdvIGFyZSBjYWxs
ZWQuIGFuZCBnZXRfbXBfYnVzX3RvX25vZGUKY291bGQgZ2V0IGNvcnJlY3Qgbm9kZSBmb3Igc3lz
ZGF0YSBpbiByb290IGJ1cy4KCmluIHNjYW5uaW5nIG9mIHJvb3QgYnVzLCBhbGwgY2hpbGQgYnVz
IHdpbGwgdGFrZSBwYXJlbnQgYnVzIHN5c2RhdGEuIFNvIGFsbApwY2lfZGV2aWNlLT5kZXYubnVt
YV9ub2RlIHdpbGwgYmUgYXNzaWduZWQgY29ycmVjdGx5IGF1dG9tYXRpY2FsbHkuCgpsYXRlciB3
ZSBjb3VsZCB1c2UgZGV2X3RvX25vZGUoJnBjaV9kZXYtPmRldikgdG8gZ2V0IG51bWFfbm9kZSwg
YW5kIHdlIGNvdWxkIGFsc28KY291bGQgbWFrZSBvdGhlciBidXMgc3BlY2lmaWMgZGV2aWNlIGdl
dCB0aGUgY29ycmVjdCBudW1hX25vZGUgdG9vLgoKdGhpcyBpcyBvbmUgdXBkYXRlIHZlcnNpb24g
dG8gcGNpX3N5c2RhdGEgYW5kIGplZmYncyBwY2lfZG9tYWluIHBhdGNoLgphbmQgZHVwbGljYXRl
ZCBzY2FuIGJ1cyBmaXggcGF0Y2gKClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWku
bHVAc3VuLmNvbT4KCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYvcGNpL01ha2VmaWxlXzMyCj09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L3BjaS9NYWtlZmlsZV8zMgorKysg
bGludXgtMi42L2FyY2gveDg2L3BjaS9NYWtlZmlsZV8zMgpAQCAtMTAsNSArMTAsNiBAQCBwY2kt
eQkJCQkrPSBsZWdhY3kubyBpcnEubwogCiBwY2ktJChDT05GSUdfWDg2X1ZJU1dTKQkJOj0gdmlz
d3MubyBmaXh1cC5vCiBwY2ktJChDT05GSUdfWDg2X05VTUFRKQkJOj0gbnVtYS5vIGlycS5vCitw
Y2ktJChDT05GSUdfTlVNQSkJCSs9IG1wX2J1c190b19ub2RlLm8KIAogb2JqLXkJCQkJKz0gJChw
Y2kteSkgY29tbW9uLm8gZWFybHkubwpJbmRleDogbGludXgtMi42L2FyY2gveDg2L3BjaS9jb21t
b24uYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9hcmNoL3g4Ni9wY2kvY29tbW9uLmMK
KysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9wY2kvY29tbW9uLmMKQEAgLTM5Niw5ICszOTYsMTQgQEAg
c3RydWN0IHBjaV9idXMgKiBfX2RldmluaXQgcGNpYmlvc19zY2FuXwogCQlyZXR1cm4gTlVMTDsK
IAl9CiAKKwlzZC0+bm9kZSA9IGdldF9tcF9idXNfdG9fbm9kZShidXNudW0pOworCiAJcHJpbnRr
KEtFUk5fREVCVUcgIlBDSTogUHJvYmluZyBQQ0kgaGFyZHdhcmUgKGJ1cyAlMDJ4KVxuIiwgYnVz
bnVtKTsKKwlidXMgPSBwY2lfc2Nhbl9idXNfcGFyZW50ZWQoTlVMTCwgYnVzbnVtLCAmcGNpX3Jv
b3Rfb3BzLCBzZCk7CisJaWYgKCFidXMpCisJCWtmcmVlKHNkKTsKIAotCXJldHVybiBwY2lfc2Nh
bl9idXNfcGFyZW50ZWQoTlVMTCwgYnVzbnVtLCAmcGNpX3Jvb3Rfb3BzLCBzZCk7CisJcmV0dXJu
IGJ1czsKIH0KIAogZXh0ZXJuIHU4IHBjaV9jYWNoZV9saW5lX3NpemU7CkBAIC01NDEsNyArNTQ2
LDcgQEAgdm9pZCBwY2liaW9zX2Rpc2FibGVfZGV2aWNlIChzdHJ1Y3QgcGNpXwogCQlwY2liaW9z
X2Rpc2FibGVfaXJxKGRldik7CiB9CiAKLXN0cnVjdCBwY2lfYnVzICpfX2RldmluaXQgcGNpX3Nj
YW5fYnVzX3dpdGhfc3lzZGF0YShpbnQgYnVzbm8pCitzdHJ1Y3QgcGNpX2J1cyAqcGNpX3NjYW5f
YnVzX29uX25vZGUoaW50IGJ1c25vLCBzdHJ1Y3QgcGNpX29wcyAqb3BzLCBpbnQgbm9kZSkKIHsK
IAlzdHJ1Y3QgcGNpX2J1cyAqYnVzID0gTlVMTDsKIAlzdHJ1Y3QgcGNpX3N5c2RhdGEgKnNkOwpA
QCAtNTU2LDEwICs1NjEsMTUgQEAgc3RydWN0IHBjaV9idXMgKl9fZGV2aW5pdCBwY2lfc2Nhbl9i
dXNfdwogCQlwcmludGsoS0VSTl9FUlIgIlBDSTogT09NLCBza2lwcGluZyBQQ0kgYnVzICUwMnhc
biIsIGJ1c25vKTsKIAkJcmV0dXJuIE5VTEw7CiAJfQotCXNkLT5ub2RlID0gLTE7Ci0JYnVzID0g
cGNpX3NjYW5fYnVzKGJ1c25vLCAmcGNpX3Jvb3Rfb3BzLCBzZCk7CisJc2QtPm5vZGUgPSBub2Rl
OworCWJ1cyA9IHBjaV9zY2FuX2J1cyhidXNubywgb3BzLCBzZCk7CiAJaWYgKCFidXMpCiAJCWtm
cmVlKHNkKTsKIAogCXJldHVybiBidXM7CiB9CisKK3N0cnVjdCBwY2lfYnVzICpwY2lfc2Nhbl9i
dXNfd2l0aF9zeXNkYXRhKGludCBidXNubykKK3sKKwlyZXR1cm4gcGNpX3NjYW5fYnVzX29uX25v
ZGUoYnVzbm8sICZwY2lfcm9vdF9vcHMsIC0xKTsKK30KSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4
Ni9wY2kvaXJxLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvcGNpL2ly
cS5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYvcGNpL2lycS5jCkBAIC0xMzYsOSArMTM2LDExIEBA
IHN0YXRpYyB2b2lkIF9faW5pdCBwaXJxX3BlZXJfdHJpY2sodm9pZCkKIAkJYnVzbWFwW2UtPmJ1
c10gPSAxOwogCX0KIAlmb3IoaSA9IDE7IGkgPCAyNTY7IGkrKykgeworCQlpbnQgbm9kZTsKIAkJ
aWYgKCFidXNtYXBbaV0gfHwgcGNpX2ZpbmRfYnVzKDAsIGkpKQogCQkJY29udGludWU7Ci0JCWlm
IChwY2lfc2Nhbl9idXNfd2l0aF9zeXNkYXRhKGkpKQorCQlub2RlID0gZ2V0X21wX2J1c190b19u
b2RlKGkpOworCQlpZiAocGNpX3NjYW5fYnVzX29uX25vZGUoaSwgJnBjaV9yb290X29wcywgbm9k
ZSkpCiAJCQlwcmludGsoS0VSTl9JTkZPICJQQ0k6IERpc2NvdmVyZWQgcHJpbWFyeSBwZWVyICIK
IAkJCSAgICAgICAiYnVzICUwMnggW0lSUV1cbiIsIGkpOwogCX0KSW5kZXg6IGxpbnV4LTIuNi9h
cmNoL3g4Ni9wY2kvazgtYnVzXzY0LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJj
aC94ODYvcGNpL2s4LWJ1c182NC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYvcGNpL2s4LWJ1c182
NC5jCkBAIC0xLDcgKzEsOSBAQAogI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KICNpbmNsdWRlIDxs
aW51eC9wY2kuaD4KKyNpbmNsdWRlIDxhc20vcGNpLWRpcmVjdC5oPgogI2luY2x1ZGUgPGFzbS9t
cHNwZWMuaD4KICNpbmNsdWRlIDxsaW51eC9jcHVtYXNrLmg+CisjaW5jbHVkZSA8bGludXgvdG9w
b2xvZ3kuaD4KIAogLyoKICAqIFRoaXMgZGlzY292ZXJzIHRoZSBwY2lidXMgPC0+IG5vZGUgbWFw
cGluZyBvbiBBTUQgSzguCkBAIC0yMCw2NCArMjIsOTYgQEAKICNkZWZpbmUgU1VCT1JESU5BVEVf
TERUX0JVU19OVU1CRVIoZHdvcmQpICgoZHdvcmQgPj4gMTYpICYgMHhGRikKICNkZWZpbmUgUENJ
X0RFVklDRV9JRF9LOEhUQ09ORklHIDB4MTEwMAogCisjZGVmaW5lIEJVU19OUiAyNTYKKworc3Rh
dGljIGludCBtcF9idXNfdG9fbm9kZVtCVVNfTlJdOworCit2b2lkIHNldF9tcF9idXNfdG9fbm9k
ZShpbnQgYnVzbnVtLCBpbnQgbm9kZSkKK3sKKwlpZiAoYnVzbnVtID49IDAgJiYgIGJ1c251bSA8
IEJVU19OUikKKwkJbXBfYnVzX3RvX25vZGVbYnVzbnVtXSA9IG5vZGU7Cit9CisKK2ludCBnZXRf
bXBfYnVzX3RvX25vZGUoaW50IGJ1c251bSkKK3sKKwlpbnQgbm9kZSA9IC0xOworCisJaWYgKGJ1
c251bSA8IDAgfHwgYnVzbnVtID4gKEJVU19OUiAtIDEpKQorCQlyZXR1cm4gbm9kZTsKKworCW5v
ZGUgPSBtcF9idXNfdG9fbm9kZVtidXNudW1dOworCisJLyoKKwkgKiBsZXQgbnVtYV9ub2RlX2lk
IHRvIGRlY2lkZSBpdCBsYXRlciBpbiBkbWFfYWxsb2NfcGFnZXMKKwkgKiBpZiB0aGVyZSBpcyBu
byByYW0gb24gdGhhdCBub2RlCisJICovCisJaWYgKG5vZGUgIT0gLTEgJiYgIW5vZGVfb25saW5l
KG5vZGUpKQorCQlub2RlID0gLTE7CisKKwlyZXR1cm4gbm9kZTsKK30KKwogLyoqCi0gKiBmaWxs
X21wX2J1c190b19jcHVtYXNrKCkKKyAqIGVhcmx5X2ZpbGxfbXBfYnVzX3RvX25vZGUoKQorICog
Y2FsbGVkIGJlZm9yZSBwY2liaW9zX3NjYW5fcm9vdCBhbmQgcGNpX3NjYW5fYnVzCiAgKiBmaWxs
cyB0aGUgbXBfYnVzX3RvX2NwdW1hc2sgYXJyYXkgYmFzZWQgYWNjb3JkaW5nIHRvIHRoZSBMRFQg
QnVzIE51bWJlcgogICogUmVnaXN0ZXJzIGZvdW5kIGluIHRoZSBLOCBub3J0aGJyaWRnZQogICov
CiBfX2luaXQgc3RhdGljIGludAotZmlsbF9tcF9idXNfdG9fY3B1bWFzayh2b2lkKQorZWFybHlf
ZmlsbF9tcF9idXNfdG9fbm9kZSh2b2lkKQogewotCXN0cnVjdCBwY2lfZGV2ICpuYl9kZXYgPSBO
VUxMOwogCWludCBpLCBqOworCXVuc2lnbmVkIHNsb3Q7CiAJdTMyIGxkdGJ1cywgbmlkOworCXUz
MiBpZDsKIAlzdGF0aWMgaW50IGxibnJbM10gPSB7CiAJCUxEVF9CVVNfTlVNQkVSX1JFR0lTVEVS
XzAsCiAJCUxEVF9CVVNfTlVNQkVSX1JFR0lTVEVSXzEsCiAJCUxEVF9CVVNfTlVNQkVSX1JFR0lT
VEVSXzIKIAl9OwogCi0Jd2hpbGUgKChuYl9kZXYgPSBwY2lfZ2V0X2RldmljZShQQ0lfVkVORE9S
X0lEX0FNRCwKLQkJCVBDSV9ERVZJQ0VfSURfSzhIVENPTkZJRywgbmJfZGV2KSkpIHsKLQkJcGNp
X3JlYWRfY29uZmlnX2R3b3JkKG5iX2RldiwgTk9ERV9JRF9SRUdJU1RFUiwgJm5pZCk7CisJZm9y
IChpID0gMDsgaSA8IEJVU19OUjsgaSsrKQorCQltcF9idXNfdG9fbm9kZVtpXSA9IC0xOworCisJ
aWYgKCFlYXJseV9wY2lfYWxsb3dlZCgpKQorCQlyZXR1cm4gLTE7CisKKwlmb3IgKHNsb3QgPSAw
eDE4OyBzbG90IDwgMHgyMDsgc2xvdCsrKSB7CisJCWlkID0gcmVhZF9wY2lfY29uZmlnKDAsIHNs
b3QsIDAsIFBDSV9WRU5ET1JfSUQpOworCQlpZiAoaWQgIT0gKFBDSV9WRU5ET1JfSURfQU1EIHwg
KFBDSV9ERVZJQ0VfSURfSzhIVENPTkZJRzw8MTYpKSkKKwkJCWJyZWFrOworCQluaWQgPSByZWFk
X3BjaV9jb25maWcoMCwgc2xvdCwgMCwgTk9ERV9JRF9SRUdJU1RFUik7CiAKIAkJZm9yIChpID0g
MDsgaSA8IE5SX0xEVF9CVVNfTlVNQkVSX1JFR0lTVEVSUzsgaSsrKSB7Ci0JCQlwY2lfcmVhZF9j
b25maWdfZHdvcmQobmJfZGV2LCBsYm5yW2ldLCAmbGR0YnVzKTsKKwkJCWxkdGJ1cyA9IHJlYWRf
cGNpX2NvbmZpZygwLCBzbG90LCAwLCBsYm5yW2ldKTsKIAkJCS8qCiAJCQkgKiBpZiB0aGVyZSBh
cmUgbm8gYnVzc2VzIGhhbmdpbmcgb2ZmIG9mIHRoZSBjdXJyZW50CiAJCQkgKiBsZHQgbGluayB0
aGVuIGJvdGggdGhlIHNlY29uZGFyeSBhbmQgc3Vib3JkaW5hdGUKIAkJCSAqIGJ1cyBudW1iZXIg
ZmllbGRzIGFyZSBzZXQgdG8gMC4KLQkJCSAqIAorCQkJICoKIAkJCSAqIFJFRC1QRU4KIAkJCSAq
IFRoaXMgaXMgc2xpZ2h0bHkgYnJva2VuIGJlY2F1c2UgaXQgYXNzdW1lcwotIAkJCSAqIEhUIG5v
ZGUgSURzID09IExpbnV4IG5vZGUgaWRzLCB3aGljaCBpcyBub3QgYWx3YXlzCisJCQkgKiBIVCBu
b2RlIElEcyA9PSBMaW51eCBub2RlIGlkcywgd2hpY2ggaXMgbm90IGFsd2F5cwogCQkJICogdHJ1
ZS4gSG93ZXZlciBpdCBpcyBwcm9iYWJseSBtb3N0bHkgdHJ1ZS4KIAkJCSAqLwogCQkJaWYgKCEo
U0VDT05EQVJZX0xEVF9CVVNfTlVNQkVSKGxkdGJ1cykgPT0gMAogCQkJCSYmIFNVQk9SRElOQVRF
X0xEVF9CVVNfTlVNQkVSKGxkdGJ1cykgPT0gMCkpIHsKIAkJCQlmb3IgKGogPSBTRUNPTkRBUllf
TERUX0JVU19OVU1CRVIobGR0YnVzKTsKIAkJCQkgICAgIGogPD0gU1VCT1JESU5BVEVfTERUX0JV
U19OVU1CRVIobGR0YnVzKTsKLQkJCQkgICAgIGorKykgeyAKLQkJCQkJc3RydWN0IHBjaV9idXMg
KmJ1czsKLQkJCQkJc3RydWN0IHBjaV9zeXNkYXRhICpzZDsKLQotCQkJCQlsb25nIG5vZGUgPSBO
T0RFX0lEKG5pZCk7Ci0JCQkJCS8qIEFsZ29yaXRobSBhIGJpdCBkdW1iLCBidXQKLSAJCQkJCSAg
IGl0IHNob3VsZG4ndCBtYXR0ZXIgaGVyZSAqLwotCQkJCQlidXMgPSBwY2lfZmluZF9idXMoMCwg
aik7Ci0JCQkJCWlmICghYnVzKQotCQkJCQkJY29udGludWU7Ci0JCQkJCWlmICghbm9kZV9vbmxp
bmUobm9kZSkpCi0JCQkJCQlub2RlID0gMDsKLQotCQkJCQlzZCA9IGJ1cy0+c3lzZGF0YTsKLQkJ
CQkJc2QtPm5vZGUgPSBub2RlOwotCQkJCX0JCQorCQkJCSAgICAgaisrKSB7CisJCQkJCWludCBu
b2RlID0gTk9ERV9JRChuaWQpOworCQkJCQltcF9idXNfdG9fbm9kZVtqXSA9ICh1bnNpZ25lZCBj
aGFyKW5vZGU7CisJCQkJfQogCQkJfQogCQl9CiAJfQogCisJZm9yIChpID0gMDsgaSA8IEJVU19O
UjsgaSsrKSB7CisJCWludCBub2RlID0gbXBfYnVzX3RvX25vZGVbaV07CisJCWlmIChub2RlID49
IDApCisJCQlwcmludGsoS0VSTl9ERUJVRyAiYnVzOiAlMDJ4IHRvIG5vZGU6ICUwMnhcbiIsIGks
IG5vZGUpOworCX0KIAlyZXR1cm4gMDsKIH0KIAotZnNfaW5pdGNhbGwoZmlsbF9tcF9idXNfdG9f
Y3B1bWFzayk7Citwb3N0Y29yZV9pbml0Y2FsbChlYXJseV9maWxsX21wX2J1c190b19ub2RlKTsK
SW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9wY2kvbGVnYWN5LmMKPT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGlu
dXgtMi42Lm9yaWcvYXJjaC94ODYvcGNpL2xlZ2FjeS5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYv
cGNpL2xlZ2FjeS5jCkBAIC0xMiw2ICsxMiw3IEBACiBzdGF0aWMgdm9pZCBfX2RldmluaXQgcGNp
Ymlvc19maXh1cF9wZWVyX2JyaWRnZXModm9pZCkKIHsKIAlpbnQgbiwgZGV2Zm47CisJbG9uZyBu
b2RlOwogCiAJaWYgKHBjaWJpb3NfbGFzdF9idXMgPD0gMCB8fCBwY2liaW9zX2xhc3RfYnVzID49
IDB4ZmYpCiAJCXJldHVybjsKQEAgLTIxLDEyICsyMiwxMyBAQCBzdGF0aWMgdm9pZCBfX2Rldmlu
aXQgcGNpYmlvc19maXh1cF9wZWVyCiAJCXUzMiBsOwogCQlpZiAocGNpX2ZpbmRfYnVzKDAsIG4p
KQogCQkJY29udGludWU7CisJCW5vZGUgPSBnZXRfbXBfYnVzX3RvX25vZGUobik7CiAJCWZvciAo
ZGV2Zm4gPSAwOyBkZXZmbiA8IDI1NjsgZGV2Zm4gKz0gOCkgewogCQkJaWYgKCFyYXdfcGNpX3Jl
YWQoMCwgbiwgZGV2Zm4sIFBDSV9WRU5ET1JfSUQsIDIsICZsKSAmJgogCQkJICAgIGwgIT0gMHgw
MDAwICYmIGwgIT0gMHhmZmZmKSB7CiAJCQkJREJHKCJGb3VuZCBkZXZpY2UgYXQgJTAyeDolMDJ4
IFslMDR4XVxuIiwgbiwgZGV2Zm4sIGwpOwogCQkJCXByaW50ayhLRVJOX0lORk8gIlBDSTogRGlz
Y292ZXJlZCBwZWVyIGJ1cyAlMDJ4XG4iLCBuKTsKLQkJCQlwY2lfc2Nhbl9idXNfd2l0aF9zeXNk
YXRhKG4pOworCQkJCXBjaV9zY2FuX2J1c19vbl9ub2RlKG4sICZwY2lfcm9vdF9vcHMsIG5vZGUp
OwogCQkJCWJyZWFrOwogCQkJfQogCQl9CkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYvcGNpL21w
X2J1c190b19ub2RlLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gL2Rldi9udWxsCisrKyBsaW51eC0yLjYvYXJj
aC94ODYvcGNpL21wX2J1c190b19ub2RlLmMKQEAgLTAsMCArMSwyMyBAQAorI2luY2x1ZGUgPGxp
bnV4L3BjaS5oPgorI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KKyNpbmNsdWRlIDxsaW51eC90b3Bv
bG9neS5oPgorCisjZGVmaW5lIEJVU19OUiAyNTYKKworc3RhdGljIHVuc2lnbmVkIGNoYXIgbXBf
YnVzX3RvX25vZGVbQlVTX05SXTsKKwordm9pZCBzZXRfbXBfYnVzX3RvX25vZGUoaW50IGJ1c251
bSwgaW50IG5vZGUpCit7CisJaWYgKGJ1c251bSA+PSAwICYmICBidXNudW0gPCBCVVNfTlIpCisJ
bXBfYnVzX3RvX25vZGVbYnVzbnVtXSA9ICh1bnNpZ25lZCBjaGFyKSBub2RlOworfQorCitpbnQg
Z2V0X21wX2J1c190b19ub2RlKGludCBidXNudW0pCit7CisJaW50IG5vZGU7CisKKwlpZiAoYnVz
bnVtIDwgMCB8fCBidXNudW0gPiAoQlVTX05SIC0gMSkpCisJCXJldHVybiAwOworCW5vZGUgPSBt
cF9idXNfdG9fbm9kZVtidXNudW1dOworCXJldHVybiBub2RlOworfQpJbmRleDogbGludXgtMi42
L2luY2x1ZGUvYXNtLXg4Ni9wY2kuaAo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9pbmNs
dWRlL2FzbS14ODYvcGNpLmgKKysrIGxpbnV4LTIuNi9pbmNsdWRlL2FzbS14ODYvcGNpLmgKQEAg
LTIwLDYgKzIwLDggQEAgc3RydWN0IHBjaV9zeXNkYXRhIHsKIH07CiAKIC8qIHNjYW4gYSBidXMg
YWZ0ZXIgYWxsb2NhdGluZyBhIHBjaV9zeXNkYXRhIGZvciBpdCAqLworZXh0ZXJuIHN0cnVjdCBw
Y2lfYnVzICpwY2lfc2Nhbl9idXNfb25fbm9kZShpbnQgYnVzbm8sIHN0cnVjdCBwY2lfb3BzICpv
cHMsCisJCQkJCSAgICBpbnQgbm9kZSk7CiBleHRlcm4gc3RydWN0IHBjaV9idXMgKnBjaV9zY2Fu
X2J1c193aXRoX3N5c2RhdGEoaW50IGJ1c25vKTsKIAogc3RhdGljIGlubGluZSBpbnQgcGNpX2Rv
bWFpbl9ucihzdHJ1Y3QgcGNpX2J1cyAqYnVzKQpJbmRleDogbGludXgtMi42L2luY2x1ZGUvYXNt
LXg4Ni90b3BvbG9neS5oCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2luY2x1ZGUvYXNt
LXg4Ni90b3BvbG9neS5oCisrKyBsaW51eC0yLjYvaW5jbHVkZS9hc20teDg2L3RvcG9sb2d5LmgK
QEAgLTE2NSw4ICsxNjUsMTkgQEAgZXh0ZXJuIGludCBfX25vZGVfZGlzdGFuY2UoaW50LCBpbnQp
OwogI2RlZmluZSBub2RlX2Rpc3RhbmNlKGEsIGIpIF9fbm9kZV9kaXN0YW5jZShhLCBiKQogI2Vu
ZGlmCiAKK2ludCBnZXRfbXBfYnVzX3RvX25vZGUoaW50IGJ1c251bSk7Cit2b2lkIHNldF9tcF9i
dXNfdG9fbm9kZShpbnQgYnVzbnVtLCBpbnQgbm9kZSk7CisKICNlbHNlIC8qIENPTkZJR19OVU1B
ICovCiAKK3N0YXRpYyBpbmxpbmUgaW50IGdldF9tcF9idXNfdG9fbm9kZShpbnQgYnVzbnVtKQor
eworCXJldHVybiAwOworfQorc3RhdGljIGlubGluZSB2b2lkIHNldF9tcF9idXNfdG9fbm9kZShp
bnQgYnVzbnVtLCBpbnQgbm9kZSkKK3sKK30KKwogI2luY2x1ZGUgPGFzbS1nZW5lcmljL3RvcG9s
b2d5Lmg+CiAKICNlbmRpZgpJbmRleDogbGludXgtMi42L2FyY2gveDg2L3BjaS9hY3BpLmMKPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvcGNpL2FjcGkuYworKysgbGludXgt
Mi42L2FyY2gveDg2L3BjaS9hY3BpLmMKQEAgLTE5MSw3ICsxOTEsMTAgQEAgc3RydWN0IHBjaV9i
dXMgKiBfX2RldmluaXQgcGNpX2FjcGlfc2NhbgogewogCXN0cnVjdCBwY2lfYnVzICpidXM7CiAJ
c3RydWN0IHBjaV9zeXNkYXRhICpzZDsKKwlpbnQgbm9kZTsKKyNpZmRlZiBDT05GSUdfQUNQSV9O
VU1BCiAJaW50IHB4bTsKKyNlbmRpZgogCiAJZG1pX2NoZWNrX3N5c3RlbShhY3BpX3BjaXByb2Jl
X2RtaV90YWJsZSk7CiAKQEAgLTIwMSw1NCArMjA0LDUzIEBAIHN0cnVjdCBwY2lfYnVzICogX19k
ZXZpbml0IHBjaV9hY3BpX3NjYW4KIAkJcmV0dXJuIE5VTEw7CiAJfQogCi0JLyogQWxsb2NhdGUg
cGVyLXJvb3QtYnVzIChub3QgcGVyIGJ1cykgYXJjaC1zcGVjaWZpYyBkYXRhLgotCSAqIFRPRE86
IGxlYWs7IHRoaXMgbWVtb3J5IGlzIG5ldmVyIGZyZWVkLgotCSAqIEl0J3MgYXJndWFibGUgd2hl
dGhlciBpdCdzIHdvcnRoIHRoZSB0cm91YmxlIHRvIGNhcmUuCi0JICovCi0Jc2QgPSBremFsbG9j
KHNpemVvZigqc2QpLCBHRlBfS0VSTkVMKTsKLQlpZiAoIXNkKSB7Ci0JCXByaW50ayhLRVJOX0VS
UiAiUENJOiBPT00sIG5vdCBwcm9iaW5nIFBDSSBidXMgJTAyeFxuIiwgYnVzbnVtKTsKLQkJcmV0
dXJuIE5VTEw7Ci0JfQotCi0Jc2QtPmRvbWFpbiA9IGRvbWFpbjsKLQlzZC0+bm9kZSA9IC0xOwot
Ci0JcHhtID0gYWNwaV9nZXRfcHhtKGRldmljZS0+aGFuZGxlKTsKKwlub2RlID0gLTE7CiAjaWZk
ZWYgQ09ORklHX0FDUElfTlVNQQorCXB4bSA9IGFjcGlfZ2V0X3B4bShkZXZpY2UtPmhhbmRsZSk7
CiAJaWYgKHB4bSA+PSAwKQotCQlzZC0+bm9kZSA9IHB4bV90b19ub2RlKHB4bSk7CisJCW5vZGUg
PSBweG1fdG9fbm9kZShweG0pOworCWlmIChub2RlICE9IC0xKQorCQlzZXRfbXBfYnVzX3RvX25v
ZGUoYnVzbnVtLCBub2RlKTsKKwllbHNlCisJCW5vZGUgPSBnZXRfbXBfYnVzX3RvX25vZGUoYnVz
bnVtKTsKICNlbmRpZgotCS8qCi0JICogTWF5YmUgdGhlIGRlc2lyZWQgcGNpIGJ1cyBoYXMgYmVl
biBhbHJlYWR5IHNjYW5uZWQuIEluIHN1Y2ggY2FzZQotCSAqIGl0IGlzIHVubmVjZXNzYXJ5IHRv
IHNjYW4gdGhlIHBjaSBidXMgd2l0aCB0aGUgZ2l2ZW4gZG9tYWluLGJ1c251bS4KLQkgKi8KKwog
CWJ1cyA9IHBjaV9maW5kX2J1cyhkb21haW4sIGJ1c251bSk7CiAJaWYgKGJ1cykgewotCQkvKgot
CQkgKiBJZiB0aGUgZGVzaXJlZCBidXMgZXhpdHMsIHRoZSBjb250ZW50IG9mIGJ1cy0+c3lzZGF0
YSB3aWxsCi0JCSAqIGJlIHJlcGxhY2VkIGJ5IHNkLgorCQkvKiBhbHJlYWR5IHNjYW5uZWQgPyov
CisJCXNkID0gYnVzLT5zeXNkYXRhOworCQlzZC0+bm9kZSA9IG5vZGU7CisJfSBlbHNlIHsKKwkJ
LyogQWxsb2NhdGUgcGVyLXJvb3QtYnVzIChub3QgcGVyIGJ1cykgYXJjaC1zcGVjaWZpYyBkYXRh
LgorCQkgKiBUT0RPOiBsZWFrOyB0aGlzIG1lbW9yeSBpcyBuZXZlciBmcmVlZC4KKwkJICogSXQn
cyBhcmd1YWJsZSB3aGV0aGVyIGl0J3Mgd29ydGggdGhlIHRyb3VibGUgdG8gY2FyZS4KIAkJICov
Ci0JCW1lbWNweShidXMtPnN5c2RhdGEsIHNkLCBzaXplb2YoKnNkKSk7Ci0JCWtmcmVlKHNkKTsK
LQl9IGVsc2UKLQkJYnVzID0gcGNpX3NjYW5fYnVzX3BhcmVudGVkKE5VTEwsIGJ1c251bSwgJnBj
aV9yb290X29wcywgc2QpOworCQlzZCA9IGt6YWxsb2Moc2l6ZW9mKCpzZCksIEdGUF9LRVJORUwp
OworCQlpZiAoIXNkKSB7CisJCQlwcmludGsoS0VSTl9FUlIgIlBDSTogT09NLCBub3QgcHJvYmlu
ZyBQQ0kgYnVzICUwMnhcbiIsCisJCQkJIGJ1c251bSk7CisJCQlyZXR1cm4gTlVMTDsKKwkJfQog
Ci0JaWYgKCFidXMpCi0JCWtmcmVlKHNkKTsKKwkJc2QtPmRvbWFpbiA9IGRvbWFpbjsKKwkJc2Qt
Pm5vZGUgPSBub2RlOworCisJCWJ1cyA9IHBjaV9zY2FuX2J1c19wYXJlbnRlZChOVUxMLCBidXNu
dW0sICZwY2lfcm9vdF9vcHMsIHNkKTsKKwkJaWYgKCFidXMpCisJCQlrZnJlZShzZCk7CisJfQog
CiAjaWZkZWYgQ09ORklHX0FDUElfTlVNQQotCWlmIChidXMgIT0gTlVMTCkgeworCWlmIChidXMp
IHsKIAkJaWYgKHB4bSA+PSAwKSB7Ci0JCQlwcmludGsoImJ1cyAlZCAtPiBweG0gJWQgLT4gbm9k
ZSAlZFxuIiwKLQkJCQlidXNudW0sIHB4bSwgcHhtX3RvX25vZGUocHhtKSk7CisJCQlwcmludGso
S0VSTl9ERUJVRyAiYnVzICUwMnggLT4gcHhtICVkIC0+IG5vZGUgJWRcbiIsCisJCQkJYnVzbnVt
LCBweG0sIG5vZGUpOwogCQl9CiAJfQogI2VuZGlmCiAKIAlpZiAoYnVzICYmIChwY2lfcHJvYmUg
JiBQQ0lfVVNFX19DUlMpKQogCQlnZXRfY3VycmVudF9yZXNvdXJjZXMoZGV2aWNlLCBidXNudW0s
IGJ1cyk7Ci0JCiAJcmV0dXJuIGJ1czsKIH0KIAo=
------=_Part_9453_17473451.1207470413923--

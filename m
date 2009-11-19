Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZKSUyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZKSUyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 15:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZKSUyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 15:54:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45736 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbZKSUyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:54:21 -0500
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 19 Nov 2009 12:48:35 -0800
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
CC: David Daney <ddaney@caviumnetworks.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Message-ID: <x7qy0oo5rggoe62v832pgmom.1258663715758@email.android.com>
Content-Type: multipart/mixed; boundary="----FP5XIOQ65UGVL8MACSQSQB2Q790PJ5"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------FP5XIOQ65UGVL8MACSQSQB2Q790PJ5
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64

T24gaTM4NiwgaWYgd2UgY2FsbCBfX2ZlbnRyeV9fIGltbWVkaWF0ZWx5IG9uIGVudHJ5IHRoZSBy
ZXR1cm4gYWRkcmVzcyB3aWxsIGJlIGluIDQoJWVzcCksIHNvIEkgZmFpbCB0byBzZWUgaG93IHlv
dSBjb3VsZCBub3QgcmVsaWFibHkgaGF2ZSB0aGUgcmV0dXJuIGFkZHJlc3MuICBPdGhlciBhcmNo
ZXMgd291bGQgaGF2ZSBkaWZmZXJlbnQgY29uc3RyYWludHMsIG9mIGNvdXJzZS4KCiJGcmVkZXJp
YyBXZWlzYmVja2VyIiA8ZndlaXNiZWNAZ21haWwuY29tPiB3cm90ZToKCj5PbiBUaHUsIE5vdiAx
OSwgMjAwOSBhdCAwMzowNTo0MVBNIC0wNTAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToNCj4+IE9u
IFRodSwgMjAwOS0xMS0xOSBhdCAyMDo0NiArMDEwMCwgRnJlZGVyaWMgV2Vpc2JlY2tlciB3cm90
ZToNCj4+ID4gT24gVGh1LCBOb3YgMTksIDIwMDkgYXQgMDI6Mjg6MDZQTSAtMDUwMCwgU3RldmVu
IFJvc3RlZHQgd3JvdGU6DQo+PiANCj4+ID4gPiAJPGZ1bmN0aW9uPjoNCj4+ID4gPiAJCWNhbGwg
X19mZW50cnlfXw0KPj4gPiA+IAkJWy4uLl0NCj4+ID4gPiANCj4+ID4gPiAJDQo+PiA+ID4gLS0g
U3RldmUNCj4+ID4gDQo+PiA+IA0KPj4gPiBJIHdvdWxkIHJlYWxseSBsaWtlIHRoaXMuIFNvIHRo
YXQgd2UgY2FuIGZvcmdldCBhYm91dCBvdGhlciBwb3NzaWJsZQ0KPj4gPiBmdXJ0aGVyIHN1cHJp
c2VzIGR1ZSB0byBzb3BoaXN0aWNhdGVkIGZ1bmN0aW9uIHByb2xvZ3VlcyBiZWVpbmcgYmVmb3Jl
DQo+PiA+IHRoZSBtY291bnQgY2FsbC4NCj4+ID4gDQo+PiA+IEFuZCBJIGd1ZXNzIHRoYXQgd291
bGQgZml4IGl0IGluIGV2ZXJ5IGFyY2hzLg0KPj4gDQo+PiBXZWxsLCBvdGhlciBhcmNocyB1c2Ug
YSByZWdpc3RlciB0byBzdG9yZSB0aGUgcmV0dXJuIGFkZHJlc3MuIEJ1dCBpdA0KPj4gd291bGQg
YWxzbyBiZSBlYXN5IHRvIGRvIChwc2V1ZG8gYXJjaCBhc3NlbWJseSk6DQo+PiANCj4+IAk8ZnVu
Y3Rpb24+Og0KPj4gCQltb3YgbHIsICglc3ApDQo+PiAJCWFkZCA4LCAlc3ANCj4+IAkJYmxyIF9f
ZmVudHJ5X18NCj4+IAkJc3ViIDgsICVzcA0KPj4gCQltb3YgKCVzcCksIGxyDQo+PiANCj4+IA0K
Pj4gVGhhdCB3YXkgdGhlIGxyIHdvdWxkIGhhdmUgdGhlIGN1cnJlbnQgZnVuY3Rpb24sIGFuZCB0
aGUgcGFyZW50IHdvdWxkDQo+PiBzdGlsbCBiZSBhdCA4KCVzcCkNCj4+IA0KPg0KPg0KPlllYWgg
cmlnaHQsIHdlIG5lZWQgYXQgbGVhc3Qgc3VjaCB2ZXJ5IHRpbnkgcHJvbG9ndWUgZm9yDQo+YXJj
aHMgdGhhdCBzdG9yZSByZXR1cm4gYWRkcmVzc2VzIGluIGEgcmVnLg0KPg0KPgkNCj4+ID4gDQo+
PiA+IFRoYXQgc2FpZCwgTGludXMgaGFkIGEgZ29vZCBwb2ludCBhYm91dCB0aGUgZmFjdCB0aGVy
ZSBtaWdodCBvdGhlciB1c2VzDQo+PiA+IG9mIG1jb3VudCBldmVuIG1vcmUgdHJpY2t5IHRoYW4g
d2hhdCBkb2VzIHRoZSBmdW5jdGlvbiBncmFwaCB0cmFjZXIsDQo+PiA+IG91dHNpZGUgdGhlIGtl
cm5lbCwgYW5kIHRob3NlIG1heSBkZXBlbmQgb24gdGhlIHN0cmljdCBBQkkgYXNzdW1wdGlvbg0K
Pj4gPiB0aGF0IDQoZWJwKSBpcyBhbHdheXMgdGhlIF9yZWFsXyByZXR1cm4gYWRkcmVzcywgYW5k
IHRoYXQgdGhyb3VnaCBhbGwNCj4+ID4gdGhlIHByZXZpb3VzIHN0YWNrIGNhbGwuIFRoaXMgaXMg
ZXZlbiBhIGNvbmNlcm4gdGhhdCBleHRyYXBvbGF0ZXMgdGhlDQo+PiA+IHNpbmdsZSBtY291bnQg
Y2FzZS4NCj4+IA0KPj4gQXMgSSBhbSBwcm9wb3NpbmcgYSBuZXcgY2FsbC4gVGhpcyBtZWFucyB0
aGF0IG1jb3VudCBzdGF5IGFzIGlzIGZvcg0KPj4gbGVnYWN5IHJlYXNvbnMuIFllcyBJIGtub3cg
dGhlcmUgZXhpc3RzIHRoZSAtZmluc3RydW1lbnQtZnVuY3Rpb25zIGJ1dA0KPj4gdGhhdCBhZGRz
IHdheSB0b28gbXVjaCBibG9hdCB0byB0aGUgY29kZS4gT25lIHNpbmdsZSBjYWxsIHRvIHRoZQ0K
Pj4gcHJvZmlsZXIgaXMgYWxsIEkgd2FudC4NCj4NCj4NCj5TdXJlLCB0aGUgcHVycG9zZSBpcyBu
b3QgdG8gY2hhbmdlIHRoZSBleGlzdGluZyAtbWNvdW50IHRoaW5nLg0KPldoYXQgSSBtZWFudCBp
cyB0aGF0IHdlIGNvdWxkIGhhdmUgLW1jb3VudCBhbmQgLXJlYWwtcmEtYmVmb3JlLWZwDQo+YXQg
dGhlIHNhbWUgdGltZSB0byBndWFyYW50ZWUgZnAgKyA0IGlzIHJlYWxseSB3aGF0IHdlIHdhbnQg
d2hpbGUNCj51c2luZyAtbWNvdW50Lg0KPg0KPlRoZSBfX2ZlbnRyeV9fIGlkZWEgaXMgbW9yZSBu
ZWF0LCBidXQgdGhlIGd1YXJhbnRlZSBvZiBhIHJlYWwgcG9pbnRlcg0KPnRvIHRoZSByZXR1cm4g
YWRkcmVzcyBpcyBzdGlsbCBzb21ldGhpbmcgdGhhdCBsYWNrcy4NCj4NCj4NCj4+ID4gDQo+PiA+
IFNvIEkgd29uZGVyIHRoYXQgYWN0dWFsbHkgdGhlIHJlYWwgcHJvYmxlbSBpcyB0aGUgbGFjayBv
ZiBzb21ldGhpbmcgdGhhdA0KPj4gPiBjb3VsZCBwcm92aWRlIHRoaXMgZ3VhcmFudGVlLiBXZSBt
YXkgbmVlZCBhIC1yZWFsLXJhLWJlZm9yZS1mcCAoeWVhaA0KPj4gPiBJIHN1Y2sgaW4gbmFtaW5n
KS4NCj4+IA0KPj4gRG9uJ3Qgd29ycnksIHNvIGRvIHRoZSBDIGNvbXBpbGVyIGZvbGtzLCBJIG1l
YW4sIGNvbWUgb24gIm1jb3VudCI/DQo+DQo+DQo+SSBndWVzcyBpdCBoYXMgYmVlbiBmaXJzdCBj
cmVhdGVkIGZvciB0aGUgc2luZ2xlIHB1cnBvc2Ugb2YgY291bnRpbmcNCj5zcGVjaWZpYyBmdW5j
dGlvbnMgYnV0IHRoZW4gaXQgaGFzIGJlZW4gdXNlZCBmb3Igd2lkZXIsIHVucHJlZGljdGVkIHVz
ZXMgOikNCj4NCgotLQpTZW50IGZyb20gbXkgbW9iaWxlIHBob25lLiBQbGVhc2UgZXhjdXNlIGFu
eSBsYWNrIG9mIGZvcm1hdHRpbmcu

------FP5XIOQ65UGVL8MACSQSQB2Q790PJ5--


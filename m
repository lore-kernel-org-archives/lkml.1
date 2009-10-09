Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbZJIByz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbZJIByz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 21:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758683AbZJIByy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 21:54:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48435 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526AbZJIByy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 21:54:54 -0400
Message-ID: <fx7s1u251gp6c9qb7os6bj98.1255053211541@email.android.com>
Subject: Re: [PATCH 06/10] x86, mce: make mce_log buffer to per-CPU
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 08 Oct 2009 18:53:31 -0700
To: Huang Ying <ying.huang@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <m0yr6tou4q0jtt5jqpd29pd0.1255053211040@email.android.com>
Content-Type: multipart/mixed; boundary="----6J08EWJ4VN62OPOXTQRQDSAGO8R1PP"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------6J08EWJ4VN62OPOXTQRQDSAGO8R1PP
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64

SW4gZ2VuZXJhbCBpdCBpcyBub3Q7IHRoZXJlIGFyZSBleGNlcHRpb25zIGZvciBjYXNlcyB3aGVy
ZSBlaXRoZXIgdGhlIG9yaWdpbmFsIHBhdGNoIG5lZWRzIHRvIGJlIHNpZ25pZmljYW50bHkgbW9k
aWZpZWQgdG8gYXBwbHkgdG8gdGhlIGN1cnJlbnQgY29kZWJhc2UsIG9yIGJlY2F1c2UgaXQgd291
bGQgY2F1c2UgYnJlYWthZ2UuCgpJbiB0aG9zZSBjYXNlcywgdXNlIHRoZSB0YWcgT3JpZ2luYWxs
eS1ieTouCgoiSHVhbmcgWWluZyIgPHlpbmcuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToKCj5PbiBN
b24sIDIwMDktMTAtMDUgYXQgMTU6NTAgKzA4MDAsIEhpZGV0b3NoaSBTZXRvIHdyb3RlOiANCj4+
IEFuZGkgS2xlZW4gd3JvdGU6DQo+PiA+PiAoVGhpcyBwaWVjZSBvcmlnaW5hdGVzIGZyb20gSHVh
bmcncyBwYXRjaCwgdGl0bGVkOg0KPj4gPj4gICJ4ODYsIE1DRTogRml4IGJ1Z3MgYW5kIGlzc3Vl
cyBvZiBNQ0UgbG9nIHJpbmcgYnVmZmVyIikNCj4+ID4gDQo+PiA+IFlvdSBzaG91bGQgdXNlIHBy
b3BlciBGcm9tOiBoZWFkZXJzIHRoZW4gZm9yIGNvcnJlY3QgYXR0cmlidXRpb24uDQo+PiA+IA0K
Pj4gPiAtQW5kaQ0KPj4gDQo+PiBJIGp1c3QgcmVmZXJyZWQgZm9sbG93aW5nIGNvbW1pdCB3ZSBh
bHJlYWR5IGhhdmU6IA0KPj4gDQo+PiA+IGNvbW1pdCA3N2UyNmNjYTIwMDEzZTkzNTJhOGRmODZh
NTQ2NDA1NDMzMDRhMjNhDQo+PiA+IEF1dGhvcjogSGlkZXRvc2hpIFNldG8gPHNldG8uaGlkZXRv
c2hpQGpwLmZ1aml0c3UuY29tPg0KPj4gPiBEYXRlOiAgIFRodSBKdW4gMTEgMTY6MDQ6MzUgMjAw
OSArMDkwMA0KPj4gPiANCj4+ID4gICAgIHg4NiwgbWNlOiBGaXggbWNlIHByaW50aW5nDQo+PiA+
IA0KPj4gPiAgICAgVGhpcyBwYXRjaDoNCj4+ID4gDQo+PiA+ICAgICAgLSBBZGRzIHByaW50X21j
ZV9oZWFkKCkgaW5zdGVhZCBvZiBmaXJzdCBmbGFnDQo+PiA+ICAgICAgLSBNYWtlcyB0aGUgaGVh
ZGVyIHRvIGJlIHByaW50ZWQgYWx3YXlzDQo+PiA+ICAgICAgLSBTdG9wcyBkb3VibGUgcHJpbnRp
bmcgb2YgY29ycmVjdGVkIGVycm9ycw0KPj4gPiANCj4+ID4gICAgIFsgVGhpcyBwb3J0aW9uIG9y
aWdpbmF0ZXMgZnJvbSBIdWFuZyBZaW5nJ3MgcGF0Y2ggXQ0KPj4gPiANCj4+ID4gICAgIE9yaWdp
bmFsbHktRnJvbTogSHVhbmcgWWluZyA8eWluZy5odWFuZ0BpbnRlbC5jb20+DQo+PiA+ICAgICBT
aWduZWQtb2ZmLWJ5OiBIaWRldG9zaGkgU2V0byA8c2V0by5oaWRldG9zaGlAanAuZnVqaXRzdS5j
b20+DQo+PiA+ICAgICBMS01MLVJlZmVyZW5jZTogPDRBMzBBQzgzLjUwMTA3MDhAanAuZnVqaXRz
dS5jb20+DQo+PiA+ICAgICBTaWduZWQtb2ZmLWJ5OiBJbmdvIE1vbG5hciA8bWluZ29AZWx0ZS5o
dT4NCj4+IA0KPj4gWW91IG1lYW4gcy9PcmlnaW5hbGx5LUZyb20vRnJvbS8sIHJpZ2h0Pw0KPj4g
DQo+PiBJJ2xsIHVwZGF0ZSBhdHRyaWJ1dGVzIGlmIHRoaXMgc2V0IG5lZWQgdG8gYmUgcmV2aXNl
ZCBvciBpZiBtYWludGFpbmVyDQo+PiAod2hvIGV4cGVjdGVkIHRvIGJlIGFibGUgdG8gc2V0IHBy
b3BlciBhdHRyaWJ1dGVzKSByZXF1ZXN0IG1lIHRvIGRvIHNvLg0KPg0KPkkgZG9uJ3QgdGhpbmsg
aXQgaXMgYSBnb29kIGNvbGxhYm9yYXRpb24gc3R5bGUgdG8gY29weSBvdGhlcnMnIHBhdGNoZXMs
DQo+ZG8gc29tZSBtb2RpZmljYXRpb24gYW5kIHNlbmQgaXQgb3V0LCBpbnN0ZWFkOg0KPg0KPi0g
Y29tbWVudCBvbiBvcmlnaW5hbCBwYXRjaGVzDQo+LSBjb21tdW5pY2F0ZSB3aXRoIHRoZSBvcmln
aW5hbCBhdXRob3IgZmlyc3RseQ0KPi0gcHJvdmlkZSBhbm90aGVyIHBhdGNoIG9uIHRvcCBvZiBv
cmlnaW5hbCBwYXRjaGVzDQo+DQo+QmVzdCBSZWdhcmRzLA0KPkh1YW5nIFlpbmcNCj4NCj4NCgot
LQpTZW50IGZyb20gbXkgbW9iaWxlIHBob25lLiBQbGVhc2UgZXhjdXNlIGFueSBsYWNrIG9mIGZv
cm1hdHRpbmcu

------6J08EWJ4VN62OPOXTQRQDSAGO8R1PP--

